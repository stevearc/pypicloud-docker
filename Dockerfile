FROM phusion/baseimage:0.9.17
MAINTAINER Steven Arcangeli <stevearc@stevearc.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install packages required
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq
RUN apt-get install -y python-pip python2.7-dev libldap2-dev libsasl2-dev
RUN pip install virtualenv
RUN virtualenv /env
RUN /env/bin/pip install pypicloud[ldap,dynamo]==0.3.5 uwsgi pastescript redis

# Add the startup service
RUN mkdir -p /etc/my_init.d
ADD pypicloud-uwsgi.sh /etc/my_init.d/pypicloud-uwsgi.sh

# Add the pypicloud config file
RUN mkdir -p /etc/pypicloud
ADD config.ini /etc/pypicloud/config.ini

# Create a working directory for pypicloud
RUN mkdir -p /var/lib/pypicloud
VOLUME /var/lib/pypicloud

# Add the command for easily creating config files
ADD make-config.sh /sbin/make-config

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
