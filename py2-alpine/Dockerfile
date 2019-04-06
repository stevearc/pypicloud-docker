FROM python:2.7-alpine3.7
MAINTAINER Steven Arcangeli <stevearc@stevearc.com>

EXPOSE 8080
WORKDIR /app/

# Install packages required
ENV PYPICLOUD_VERSION 1.0.11
RUN apk add --no-cache --virtual build-deps python2-dev mariadb-dev postgresql-dev build-base linux-headers openldap-dev && \
  apk add --no-cache libldap libpq mariadb-client-libs util-linux-dev libffi-dev && \
  pip install pypicloud[all_plugins]==$PYPICLOUD_VERSION requests uwsgi pastescript mysqlclient psycopg2-binary && \
  adduser -D -s /bin/sh -h /var/lib/pypicloud/ pypicloud && \
  apk del --no-cache build-deps && \
  mkdir -p /etc/pypicloud

# Add the command for easily creating config files
ADD config.ini /etc/pypicloud/config.ini
ADD make-config.sh /usr/local/bin/make-config

# Create a working directory for pypicloud
VOLUME /var/lib/pypicloud

# Run as pypicloud user
USER pypicloud

CMD ["uwsgi", "--die-on-term", "/etc/pypicloud/config.ini"]
