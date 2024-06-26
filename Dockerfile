ARG PYTHON_VERSION=3.11-slim-bullseye

# define an alias for the specfic python version used in this file.
FROM python:${PYTHON_VERSION} as python

# Python build stage
FROM python as python-build-stage

# Install apt packages
RUN apt-get update && apt-get install --no-install-recommends -y --fix-missing \
  # dependencies for building Python packages
  build-essential \
  # psycopg2 dependencies
  libpq-dev \
  libffi-dev \
  libpcre3 \
  libpcre3-dev \
  git \
  python3-all-dev && python -m pip install -U pip poetry

# Requirements are installed here to ensure they will be cached.
# Create Python Dependency and Sub-Dependency Wheels.
COPY pyproject.toml poetry.lock ./

RUN poetry run pip install --upgrade pip\
  && poetry export -f requirements.txt -o requirements.txt --without-hashes\
  && pip wheel --wheel-dir /usr/src/app/wheels -r requirements.txt

# Python 'run' stage
FROM python as python-run-stage

ARG APP_HOME=/app

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR ${APP_HOME}

# Install required system dependencies
RUN apt-get update && apt-get install --no-install-recommends -y --fix-missing\
  # psycopg2 dependencies
  libpq-dev \
  # Translations dependencies
  gettext \
  git \
  htop \
  # cleaning up unused files
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

# All absolute dir copies ignore workdir instruction. All relative dir copies are wrt to the workdir instruction
# copy python dependency wheels from python-build-stage
COPY --from=python-build-stage /usr/src/app/wheels  /wheels/

# use wheels to install python dependencies
RUN pip install -U pip && pip install --no-cache-dir --no-index --find-links=/wheels/ /wheels/* \
    && rm -rf /wheels/

# copy application code to WORKDIR
COPY ./ ${APP_HOME}

ENTRYPOINT ["python", "app.py"]
