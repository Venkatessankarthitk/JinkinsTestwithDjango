FROM python:3.8
ENV PYTHONUNBUFFERED 1
WORKDIR /code                 # creates the directory too
RUN pip install pipenv
COPY Pipfile Pipfile.lock ./  # <-- add this
RUN pipenv install
COPY . ./
EXPOSE 8000                   # typical metadata

# Remove "pipenv run", add the bind argument
# (No need to repeat `command:` in `docker-compose.yml`)
CMD python manage.py runserver 0.0.0.0:8000
