# Sample python development container
## Instructions
- Open the folder in vs code
- Open the command palette and run `Dev Containers: Reopen in container`
- Open terminal and run `poetry install` and `npm install`
- Navigate in terminal to backed folder and run `poetry install`
- Navigate in terminal to frontend folder and run `npm install` and `npm run build`
- Make sure that you have pytest configured properly to run the tests
  - It is possible to rename sapmle.env to .env and change the values as needed
  - It is possible to rename sample.vscode folder to .vscode to apply the settings in the container
  - In VS Code preference -> settings:
    - Search for the word `testing`
    - Make sure that all tabs have the same values for al tabs (user, Remote [Dev container] and workspace) for Python
      - Cwd - ${workspaceFolder}/python-react-project/backend
      - Pytest args
        - --rootdir=${workspaceFolder}/python-react-project/backend
        - -c
        - ${workspaceFolder}/python-react-project/backend/pytest.ini
        - tests
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
- The front is using react with chakra ui and written in typescript
- The project can be deployed localy by running `docker-compose up`
