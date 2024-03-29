FROM phusion/baseimage:focal-1.1.0
MAINTAINER Steven Arcangeli <stevearc@stevearc.com>

ENV PYPICLOUD_VERSION 1.3.12

EXPOSE 8080

# Install packages required
RUN --mount=type=tmpfs,target=/root/.cargo \
  apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy python3-pip \
     python3-dev libldap2-dev libsasl2-dev libmysqlclient-dev libffi-dev libssl-dev apache2-utils \
     cargo libpq-dev \
  && python3 -m pip install --no-cache-dir --upgrade pip \
  && python3 -m pip install --no-cache-dir --upgrade setuptools \
  && python3 -m pip install --no-cache-dir pypicloud[all_plugins]==$PYPICLOUD_VERSION \
    requests uwsgi pastescript mysqlclient psycopg2-binary bcrypt \
  # Create the pypicloud user
  && groupadd -r pypicloud \
  && useradd -r -g pypicloud -d /var/lib/pypicloud -m pypicloud \
  # Make sure this directory exists for the baseimage init
  && mkdir -p /etc/my_init.d

# Add the startup service
ADD pypicloud-uwsgi.sh /etc/my_init.d/pypicloud-uwsgi.sh

# Add the pypicloud config file
RUN mkdir -p /etc/pypicloud
ADD config.ini /etc/pypicloud/config.ini

# Create a working directory for pypicloud
VOLUME /var/lib/pypicloud

# Add the command for easily creating config files
ADD make-config.sh /usr/local/bin/make-config

# Add an environment variable that pypicloud-uwsgi.sh uses to determine which
# user to run as
ENV UWSGI_USER pypicloud

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
