#!/bin/sh

cd /opt
gunicorn -w 4 -b 127.0.0.1:5001 myweb:app &
