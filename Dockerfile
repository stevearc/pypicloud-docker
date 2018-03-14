FROM python:3.6-alpine3.7
MAINTAINER Steven Arcangeli <stevearc@stevearc.com>

EXPOSE 8080
WORKDIR /app/

# Add the command for easily creating config files
ADD config.ini /app/config.ini
ADD make-config.sh /app/make-config

# Install packages required
ENV PYPICLOUD_VERSION 1.0.2
RUN apk add --no-cache --virtual build-deps python3-dev mariadb-dev postgresql-dev build-base linux-headers openldap-dev && \
  pip install pypicloud[ldap,dynamo]==$PYPICLOUD_VERSION requests uwsgi pastescript redis mysqlclient psycopg2 && \
  adduser -D -s /bin/bash -h /var/lib/pypicloud/ pypicloud && \
  apk del --no-cache build-deps && \
  apk add --no-cache libldap libpq mariadb-libs util-linux-dev

# Create a working directory for pypicloud
VOLUME /var/lib/pypicloud

CMD ["uwsgi", "--die-on-term", "/app/config.ini"]
