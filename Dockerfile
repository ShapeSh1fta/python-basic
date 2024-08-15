# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV POETRY_VERSION=1.6.1

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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