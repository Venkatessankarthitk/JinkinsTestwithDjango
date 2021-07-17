


FROM python:3.9-slim

# Create a group and user to run our app
ARG APP_USER=appuser
RUN groupadd -r ${APP_USER} && useradd --no-log-init -r -g ${APP_USER} ${APP_USER}

RUN set -ex \
    && BUILD_DEPS=" \
    binutils \
    libproj-dev \
    gdal-bin \
    " \
    && apt-get update && apt-get install -y --no-install-recommends $BUILD_DEPS \
    && pip install pipenv \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED 1
WORKDIR /code                 # creates the directory too
RUN pip install pipenv
COPY Pipfile Pipfile.lock  
RUN pipenv install
COPY . ./

# uWSGI will listen on this port
EXPOSE 8000

# Add any static environment variables needed by Django or your settings file here:
ENV DJANGO_SETTINGS_MODULE=my_project.settings.deploy

# Call collectstatic (customize the following line with the minimal environment variables needed for manage.py to run):
# RUN DATABASE_URL=''  python manage.py collectstatic --noinput

# Tell uWSGI where to find your wsgi file (change this):
ENV UWSGI_WSGI_FILE=my_project/wsgi.py

# Base uWSGI configuration (you shouldn't need to change these):
ENV UWSGI_HTTP=:8000 UWSGI_MASTER=1 UWSGI_HTTP_AUTO_CHUNKED=1 UWSGI_HTTP_KEEPALIVE=1 UWSGI_LAZY_APPS=1 UWSGI_WSGI_ENV_BEHAVIOR=holy

# Number of uWSGI workers and threads per worker (customize as needed):
ENV UWSGI_WORKERS=2 UWSGI_THREADS=4

# uWSGI static file serving configuration (customize or comment out if not needed):
ENV UWSGI_STATIC_MAP="/static/=/code/static/" UWSGI_STATIC_EXPIRES_URI="/static/.*\.[a-f0-9]{12,}\.(css|js|png|jpg|jpeg|gif|ico|woff|ttf|otf|svg|scss|map|txt) 315360000"

# Deny invalid hosts before they get to Django (uncomment and change to your hostname(s)):
# ENV UWSGI_ROUTE_HOST="^(?!localhost:8000$) break:400"

# Change to a non-root user
USER ${APP_USER}:${APP_USER}

# Uncomment after creating your docker-entrypoint.sh
# ENTRYPOINT ["/code/docker-entrypoint.sh"]

# Start uWSGI
# CMD ["uwsgi", "--show-config"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.wsgi"]

