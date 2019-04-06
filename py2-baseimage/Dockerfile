FROM phusion/baseimage:0.10.0
MAINTAINER Steven Arcangeli <stevearc@stevearc.com>

ENV PYPICLOUD_VERSION 1.0.11

EXPOSE 8080

# Install packages required
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy python-pip \
     python2.7-dev libldap2-dev libsasl2-dev libmysqlclient-dev libffi-dev libssl-dev \
  && pip install pypicloud[all_plugins]==$PYPICLOUD_VERSION requests uwsgi \
     pastescript mysqlclient psycopg2-binary \
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
