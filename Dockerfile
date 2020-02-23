FROM ilcm96/uwsgi-nginx:pyhton3.8-buster

RUN pip install flask Flask-Caching requests
RUN apt-get update \
    && apt-get --no-install-recommends --no-install-suggests -y install wget unzip
# URL under which static (not modified by Python) files will be requested
# They will be served by Nginx directly, without being handled by uWSGI
ENV STATIC_URL /static
# Absolute path in where the static files wil be
ENV STATIC_PATH /app/static

# If STATIC_INDEX is 1, serve / with /static/index.html directly (or the static URL configured)
# ENV STATIC_INDEX 1
ENV STATIC_INDEX 0

# Download latest neis-api and unzip
WORKDIR /tmp
RUN rm -rf /app/* \
    && wget https://github.com/ilcm96/neis-api/archive/master.zip \
    && unzip master.zip \
    && apt-get remove --purge -y wget unzip \
    && cp -rf ./neis-api-master/meal/* /app \
    && rm -rf /tmp/*
WORKDIR /app

# Make /app/* available to be imported by Python globally to better support several use cases like Alembic migrations.
ENV PYTHONPATH=/app

# Move the base entrypoint to reuse it
RUN mv /entrypoint.sh /uwsgi-nginx-entrypoint.sh
# Copy the entrypoint that will generate Nginx additional configs
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Run the start script provided by the parent image tiangolo/uwsgi-nginx.
# It will check for an /app/prestart.sh script (e.g. for migrations)
# And then will start Supervisor, which in turn will start Nginx and uWSGI
CMD ["/start.sh"]
