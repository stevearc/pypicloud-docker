FROM python:2.7-alpine3.7
MAINTAINER Steven Arcangeli <stevearc@stevearc.com>

EXPOSE 8080
WORKDIR /app/

# Install packages required
ENV PYPICLOUD_VERSION 1.0.3
RUN apk add --no-cache --virtual build-deps python2-dev mariadb-dev postgresql-dev build-base linux-headers openldap-dev && \
  pip install pypicloud[ldap,dynamo]==$PYPICLOUD_VERSION requests uwsgi pastescript redis mysqlclient psycopg2 && \
  adduser -D -s /bin/bash -h /var/lib/pypicloud/ pypicloud && \
  apk del --no-cache build-deps && \
  apk add --no-cache libldap libpq mariadb-client-libs util-linux-dev && \
  mkdir -p /etc/pypicloud

# Add the command for easily creating config files
ADD config.ini /etc/pypicloud/config.ini
ADD make-config.sh /usr/local/bin/make-config

# Create a working directory for pypicloud
VOLUME /var/lib/pypicloud

CMD ["uwsgi", "--die-on-term", "/etc/pypicloud/config.ini"]
