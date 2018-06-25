#!/bin/sh
if [ -z "$UWSGI_USER" ] || [ "$UWSGI_USER" = "root" ]; then
  uwsgi --die-on-term /etc/pypicloud/config.ini
else
  /sbin/setuser "$UWSGI_USER" uwsgi --die-on-term /etc/pypicloud/config.ini
fi
