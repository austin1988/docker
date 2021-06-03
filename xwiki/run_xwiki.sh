#!/bin/bash

CONTAINER=xwiki

case "$1" in
  start)
    echo "Starting $CONTAINER container"
    docker-compose up -d
    echo "result:$?"
    ;;
  stop)
    echo "Stopping $CONTAINER container"
    docker-compose down --volumes
    echo "result:$?"
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  status)
    docker ps -a 
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
esac
