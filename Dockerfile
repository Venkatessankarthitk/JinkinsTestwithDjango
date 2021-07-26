FROM python:3.9-slim

# Create a group and user to run our app
ARG APP_USER=appuser
RUN groupadd -r ${APP_USER} && useradd --no-log-init -r -g ${APP_USER} ${APP_USER}

RUN set -ex \
    && RUN_DEPS=" \
    libpcre3 \
    mime-support \
    postgresql-client \
    " \
    && seq 1 8 | xargs -I{} mkdir -p /usr/share/man/man{} \
    && apt-get update && apt-get install -y --no-install-recommends $RUN_DEPS \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && BUILD_DEPS=" \
    binutils \
    libproj-dev \
    gdal-bin \
    python3-dev \
    linux-headers-4.19.0-16-all \
    libpcre3-dev \
    " \
    && apt-get update && apt-get install -y --no-install-recommends $BUILD_DEPS
RUN apt-get install -y binutils libproj-dev gdal-bin
RUN pip install pipenv
RUN pip install pgcli
RUN pip install psycopg2-binary pgspecial --no-deps
RUN pip install pgcli --no-deps
RUN apt-get install -y uwsgi-plugin-python3
RUN apt-get install -y gcc 
RUN apt-get install -y build-essential
RUN pip install uwsgi

RUN mkdir /app/
# WORKDIR /app/
# COPY ./Pipfile* /app/
# RUN pipenv install --skip-lock
# ADD . /app/
ENV PYTHONUNBUFFERED 1
WORKDIR /app/
RUN pip install pipenv
COPY Pipfile* /app/
RUN cd /app && pipenv install --deploy --system
COPY . /app/
RUN pip install gunicorn

# uWSGI will listen on this port
EXPOSE 8000

# Add any static environment variables needed by Django or your settings file here:
#ENV DJANGO_SETTINGS_MODULE=my_project.settings.deploy

# Call collectstatic (customize the following line with the minimal environment variables needed for manage.py to run):
# RUN DATABASE_URL=''  python manage.py collectstatic --noinput

# Tell uWSGI where to find your wsgi file (change this)

# Uncomment after creating your docker-entrypoint.sh
#ENTRYPOINT ["/code/docker-entrypoint.sh"]

# Start uWSGI
ENTRYPOINT ["pipenv", "run"]
CMD  ["gunicorn",  "--bind", "0.0.0.0:8000", "icarus_api.wsgi:application"]
