#!/bin/sh
/sbin/setuser pypicloud /env/bin/uwsgi --die-on-term /etc/pypicloud/config.ini
