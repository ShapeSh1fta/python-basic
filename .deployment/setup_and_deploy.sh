#!/bin/bash

# Define the path to your Terraform configuration files
TERRAFORM_DIR="./terraform"
REMOTE_TERRAFORM_DIR="/home/$USER/terraform"

# Define the path to your .tfvars files directory
TFVARS_DIR="$TERRAFORM_DIR/tfvars"
REMOTE_TFVARS_DIR="$REMOTE_TERRAFORM_DIR/tfvars"

# Function to collect all .tfvars files in the directory
collect_tfvars_files() {
    TFVARS_FILES=""
    for file in $TFVARS_DIR/*.tfvars; do
        TFVARS_FILES="$TFVARS_FILES -var-file=$file"
    done
    echo $TFVARS_FILES
}

# Function to install Terraform, Helm, kubectl, and ArgoCD CLI
install_tools() {
    # Install Terraform
    wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
    unzip terraform_1.5.0_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    rm terraform_1.5.0_linux_amd64.zip

    # Install kubectl
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl

    # Install Helm
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

    # Optional: Install ArgoCD CLI
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v2.8.0/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64
}

# Function to authenticate with AWS
authenticate_aws() {
    if ! aws sts get-caller-identity > /dev/null 2>&1; then
        echo "AWS CLI not authenticated. Please authenticate with AWS CLI."
        aws configure
    fi
}

# Function to authenticate with GCP
authenticate_gcp() {
    if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep '@' > /dev/null 2>&1; then
        echo "GCP CLI not authenticated. Please authenticate with GCP CLI."
        gcloud auth login
    fi
}

# Function to launch an AWS EC2 instance and configure it
launch_aws_instance() {
    echo "Launching AWS EC2 instance..."

    # Authenticate with AWS
    authenticate_aws

    # Launch EC2 instance
    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id ami-0c55b159cbfafe1f0 \  # Update with appropriate AMI ID
        --count 1 \
        --instance-type t2.micro \
        --key-name your-key-pair \
        --security-group-ids sg-12345678 \   # Update with appropriate security group ID
        --subnet-id subnet-12345678 \        # Update with appropriate subnet ID
        --query "Instances[0].InstanceId" \
        --output text)

    echo "EC2 Instance ID: $INSTANCE_ID"

    # Wait for the instance to be running
    aws ec2 wait instance-running --instance-ids $INSTANCE_ID

    # Get the public IP of the instance
    PUBLIC_IP=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query "Reservations[0].Instances[0].PublicIpAddress" \
        --output text)

    echo "EC2 Instance Public IP: $PUBLIC_IP"

    # Transfer Terraform files and .tfvars files to the EC2 instance
    scp -o "StrictHostKeyChecking=no" -i your-key-pair.pem -r $TERRAFORM_DIR ec2-user@$PUBLIC_IP:$REMOTE_TERRAFORM_DIR
    scp -o "StrictHostKeyChecking=no" -i your-key-pair.pem -r $TFVARS_DIR ec2-user@$PUBLIC_IP:$REMOTE_TFVARS_DIR

    # Execute installation and Terraform commands on the instance
    ssh -o "StrictHostKeyChecking=no" -i your-key-pair.pem ec2-user@$PUBLIC_IP << EOF
        $(declare -f install_tools)
        install_tools

        # Navigate to Terraform directory and run Terraform commands
        cd $REMOTE_TERRAFORM_DIR

        # Collect all .tfvars files
        TFVARS_FILES=""
        for file in $REMOTE_TFVARS_DIR/*.tfvars; do
            TFVARS_FILES="\$TFVARS_FILES -var-file=\$file"
        done

        # Initialize and apply Terraform with multiple .tfvars files
        terraform init
        terraform plan \$TFVARS_FILES -var="provider=eks" -out=tfplan
        terraform apply "tfplan"

        # Install ArgoCD onto the cluster
        echo "Installing ArgoCD..."
        kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
EOF
}

# Function to launch a GCP VM instance and configure it
launch_gcp_instance() {
    echo "Launching GCP VM instance..."

    # Authenticate with GCP
    authenticate_gcp

    # Create a new GCP instance
    INSTANCE_NAME="terraform-instance"
    ZONE="us-central1-a"
    gcloud compute instances create $INSTANCE_NAME \
        --zone=$ZONE \
        --machine-type=e2-micro \
        --image-family=debian-10 \
        --image-project=debian-cloud \
        --tags=http-server,https-server

    # Wait for the instance to be ready
    while [[ $(gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE --format='get(status)') != "RUNNING" ]]; do
        echo "Waiting for instance to start..."
        sleep 5
    done

    # Get the public IP of the instance
    PUBLIC_IP=$(gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
    echo "GCP VM Instance Public IP: $PUBLIC_IP"

    # Transfer Terraform files and .tfvars files to the GCP instance
    gcloud compute scp --zone=$ZONE --recurse $TERRAFORM_DIR $USER@$INSTANCE_NAME:$REMOTE_TERRAFORM_DIR
    gcloud compute scp --zone=$ZONE --recurse $TFVARS_DIR $USER@$INSTANCE_NAME:$REMOTE_TFVARS_DIR

    # Execute installation and Terraform commands on the instance
    gcloud compute ssh $USER@$INSTANCE_NAME --zone=$ZONE --command "
        $(declare -f install_tools)
        install_tools

        # Navigate to Terraform directory and run Terraform commands
        cd $REMOTE_TERRAFORM_DIR

        # Collect all .tfvars files
        TFVARS_FILES=\"\"
        for file in $REMOTE_TFVARS_DIR/*.tfvars; do
            TFVARS_FILES=\"\$TFVARS_FILES -var-file=\$file\"
        done

        # Initialize and apply Terraform with multiple .tfvars files
        terraform init
        terraform plan \$TFVARS_FILES -var=\"provider=gke\" -out=tfplan
        terraform apply \"tfplan\"

        # Install ArgoCD onto the cluster
        echo \"Installing ArgoCD...\"
        kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    "
}

# Main logic
CLOUD_PROVIDER="$1"

if [ -z "$CLOUD_PROVIDER" ]; then
    echo "Usage: $0 <provider>"
    echo "Provider must be one of: aws, gcp"
    exit 1
fi

if [ "$CLOUD_PROVIDER" == "aws" ]; then
    launch_aws_instance
elif [ "$CLOUD_PROVIDER" == "gcp" ]; then
    launch_gcp_instance
else
    echo "Invalid provider specified. Please use 'aws' or 'gcp'."
    exit 1
fi
