# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV POETRY_VERSION=1.6.1

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    software-properties-common \
    git \
    curl \
    wget \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm (required for TypeScript and React)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Install TypeScript globally
RUN npm install -g typescript

# Install create-react-app for React development
RUN npm install -g create-react-app

# Terraform installation
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
            gpg --dearmor | \
            sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && apt-get install terraform  

# Install aws cli
RUN sudo apt install awscli -y

# Install gcloud and kubectl
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
    http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && apt-get install google-cloud-cli kubectl -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Add Poetry to PATH
ENV PATH="/root/.local/bin:$PATH"

# Set work directory
WORKDIR /workspace

# Copy the current directory contents into the container
COPY . .

# Install dependencies defined in pyproject.toml (if present)
RUN poetry install || true

# Install dependencies defined in package.json (if present)
RUN npm install || true