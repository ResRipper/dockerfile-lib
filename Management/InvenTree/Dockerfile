# Modified from Official Dockerfile:
# https://github.com/inventree/InvenTree/blob/master/Dockerfile

# production:
# - Required files are copied into the image
# - Runs InvenTree web server under gunicorn

FROM python:3.11.2-slim-bullseye

ENV PYTHONUNBUFFERED 1

# Build arguments for this image
ARG commit_hash=""
ARG commit_date=""
ARG commit_tag=""

# Ref: https://github.com/pyca/cryptography/issues/5776
ENV CRYPTOGRAPHY_DONT_BUILD_RUST 1

ENV INVENTREE_LOG_LEVEL="WARNING"
ENV INVENTREE_DOCKER="true"

# InvenTree paths
ENV INVENTREE_HOME="/home/inventree"
ENV INVENTREE_MNG_DIR="${INVENTREE_HOME}/InvenTree"
ENV INVENTREE_DATA_DIR="${INVENTREE_HOME}/data"
ENV INVENTREE_STATIC_ROOT="${INVENTREE_DATA_DIR}/static"
ENV INVENTREE_MEDIA_ROOT="${INVENTREE_DATA_DIR}/media"
ENV INVENTREE_BACKUP_DIR="${INVENTREE_DATA_DIR}/backup"
ENV INVENTREE_PLUGIN_DIR="${INVENTREE_DATA_DIR}/plugins"

# InvenTree configuration files
ENV INVENTREE_CONFIG_FILE="${INVENTREE_DATA_DIR}/config.yaml"
ENV INVENTREE_SECRET_KEY_FILE="${INVENTREE_DATA_DIR}/secret_key.txt"
ENV INVENTREE_PLUGIN_FILE="${INVENTREE_DATA_DIR}/plugins.txt"

# Worker configuration (can be altered by user)
ENV INVENTREE_GUNICORN_WORKERS="4"
ENV INVENTREE_BACKGROUND_WORKERS="4"

# Default web server address:port
ENV INVENTREE_WEB_ADDR=0.0.0.0
ENV INVENTREE_WEB_PORT=8000

# Install required system packages
RUN apt-get update && \
    apt-get install -y  --no-install-recommends \
    git gcc g++ gettext gnupg libffi-dev \
    # Weasyprint requirements : https://doc.courtbouillon.org/weasyprint/stable/first_steps.html#debian-11
    poppler-utils libpango-1.0-0 libpangoft2-1.0-0 \
    # Image format support
    libjpeg-dev webp libwebp-dev \
    # SQLite support
    sqlite3 \
    # PostgreSQL support
    libpq-dev postgresql-client \
    # MySQL / MariaDB support
    default-libmysqlclient-dev mariadb-client && \
    apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# Install required base-level python packages
COPY ./docker/requirements.txt base_requirements.txt
RUN pip install --disable-pip-version-check -U -r base_requirements.txt

# InvenTree production image:
# - Copies required files from local directory
# - Installs required python packages from requirements.txt
# - Starts a gunicorn webserver

ENV INVENTREE_DEBUG=False

# As .git directory is not available in production image, we pass the commit information via ENV
ENV INVENTREE_COMMIT_HASH="${commit_hash}"
ENV INVENTREE_COMMIT_DATE="${commit_date}"

# Copy source code
COPY InvenTree ${INVENTREE_HOME}/InvenTree

# Copy other key files
COPY requirements.txt ${INVENTREE_HOME}/requirements.txt
COPY tasks.py ${INVENTREE_HOME}/tasks.py
COPY docker/gunicorn.conf.py ${INVENTREE_HOME}/gunicorn.conf.py
COPY docker/init.sh ${INVENTREE_MNG_DIR}/init.sh

# Need to be running from within this directory
WORKDIR ${INVENTREE_MNG_DIR}

# Drop to the inventree user for the production image
#RUN adduser inventree
#RUN chown -R inventree:inventree ${INVENTREE_HOME}
#USER inventree

# Install InvenTree packages
RUN pip3 install --user --disable-pip-version-check -r ${INVENTREE_HOME}/requirements.txt

# Server init entrypoint
ENTRYPOINT ["/bin/bash", "./init.sh"]

# Launch the production server
# TODO: Work out why environment variables cannot be interpolated in this command
# TODO: e.g. -b ${INVENTREE_WEB_ADDR}:${INVENTREE_WEB_PORT} fails here
CMD gunicorn -c ./gunicorn.conf.py InvenTree.wsgi -b 0.0.0.0:8000 --chdir ./InvenTree
