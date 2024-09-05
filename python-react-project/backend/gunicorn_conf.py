from multiprocessing import cpu_count

# Socket Path
bind = '0.0.0.0:8000'

# Worker Options
workers = cpu_count() + 1
worker_class = 'uvicorn.workers.UvicornWorker'

# Logging Options
loglevel = 'debug'
accesslog = '/var/log/gunicorn/access.log'
errorlog = '/var/log/gunicorn/error.log'