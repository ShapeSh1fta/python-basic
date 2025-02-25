# Stage 1: Build frontend
FROM node:22 AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Obfuscate JavaScript
FROM node:22 AS js-obfuscator
WORKDIR /app
COPY --from=frontend-build /app/frontend/build ./build
RUN npm install -g javascript-obfuscator
RUN find ./build -name '*.js' -exec javascript-obfuscator {} --output {} \;

# Stage 3: Build backend
FROM python:3.12-slim AS backend-build
WORKDIR /app/backend
RUN pip install poetry
COPY backend/pyproject.toml backend/poetry.lock* ./
RUN poetry config virtualenvs.create false \
    && poetry install
COPY backend/ ./

# Stage 4: Final image
FROM python:3.12-slim
WORKDIR /app/backend
COPY --from=backend-build /app/backend/app ./app
COPY --from=backend-build /app/backend/pyproject.toml ./pyproject.toml
COPY --from=backend-build /app/backend/poetry.lock ./poetry.lock
COPY --from=backend-build /app/backend/gunicorn_conf.py ./gunicorn_conf.py
# Place frontend files one level up relative to backend
COPY --from=js-obfuscator /app/build /app/frontend/build
COPY --from=backend-build /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=backend-build /usr/local/bin /usr/local/bin


RUN pip install gunicorn uvicorn poetry

# Create log directory for Gunicorn
RUN mkdir -p /var/log/gunicorn

# Verify the directory structure
RUN ls -la /app/frontend/build/static || echo "Static directory not found"

EXPOSE 8000 8001

# Copy the start script and make it executable
COPY backend/start.sh ./start.sh
RUN chmod +x start.sh

# Additional debug to show exact file location
RUN find /app -name "websocket_server.py"

# Use the start script to run both Gunicorn and WebSocket server
CMD ["./start.sh"]
# Automatically start FastAPI using Uvicorn or Gunicorn
# CMD tail -f /dev/null
# CMD ["poetry", "run", "uvicorn", "backend.app.main:app", "--host", "0.0.0.0", "--port", "8000"]