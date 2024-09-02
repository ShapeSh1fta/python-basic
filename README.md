# Sample python development container
## Overview
- This is a sample project that was developed in vs code on a devcontainer setup
- The project contains the necessary initial dev ops as code (Terraform) to be deployed on GCP/AWS more specifically on a kubernetes
  cluster EKS/GKE
- The solution is intendent for a python micro services solution
- The devcontainer docker contains all the necessary tools (aws cli, gcloud, terraform, poetry)
- The project itself contains also a docker to be used in deployment
## Devops deployment
- Make sure to extend and replace all the necessary values
- Before running setup_and_deploy.sh make sure that you are logged into your cloud provider through cli and send the provider as parameter to the bash (aws/gcp)
## Project specifics
- The project is just a sample to run FastAPI backend over Gunicorn as recommended by [GeeksForGeeks](https://www.geeksforgeeks.org/fast-api-gunicorn-vs-uvicorn/)