#!/bin/bash

CONTAINER=svn-server 

cat << EOF > docker-compose.yml
version: '2'
services:
  svn-server:
    image: garethflowers/svn-server
    volumes:
      - "./svn-repo:/var/opt/svn"
    ports:
      - "3690:3690"
    container_name: svn-server
    networks: 
      - dev
    stdin_open: true
    tty: true

networks:
  dev:
    driver: bridge 
EOF

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

rm docker-compose.yml
