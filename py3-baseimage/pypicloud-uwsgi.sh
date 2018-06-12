#!/bin/sh
/sbin/setuser pypicloud uwsgi --die-on-term /etc/pypicloud/config.ini
