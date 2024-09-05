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
    && poetry install --no-dev --no-interaction --no-ansi
COPY backend/ ./

# Stage 4: Final image
FROM python:3.12-slim
WORKDIR /app
COPY --from=backend-build /app/backend ./backend
COPY --from=js-obfuscator /app/build ./frontend/build

RUN pip install gunicorn

# Create log directory for Gunicorn
RUN mkdir -p /var/log/gunicorn

EXPOSE 8000 8001

# # Use Gunicorn to serve the application
# CMD ["gunicorn", "--chdir", "backend", "--conf", "backend/gunicorn_conf.py", "app.main:app"]
# Copy the start script and make it executable
COPY backend/start.sh ./
RUN chmod +x start.sh

# Use the start script to run both Gunicorn and WebSocket server
CMD ["./start.sh"]