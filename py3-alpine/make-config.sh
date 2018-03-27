#!/bin/sh
if [ -z "$1" ]; then
  ppc-make-config -r
else
  ppc-make-config "$@"
fi
