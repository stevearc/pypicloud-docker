#!/bin/sh
if [ -z "$1" ]; then
  /env/bin/ppc-make-config -r
else
  /env/bin/ppc-make-config "$@"
fi
