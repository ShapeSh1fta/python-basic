#!/bin/bash

# Start Gunicorn
gunicorn --chdir backend --conf backend/gunicorn_conf.py app.main:app &

# Start WebSocket server
python backend/websocket_server.py &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?