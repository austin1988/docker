#!/bin/bash

CONTAINER=draw.io 

if [ ! -d docker-draw.io ]; then
    echo "get docker-draw.io ..."
    git clone https://github.com/fjudith/docker-draw.io.git
fi

cd docker-draw.io


cat << EOF > docker-compose.patch
--- docker-compose.yml	2020-10-02 19:58:16.000000000 +0800
+++ docker-compose-b.yml	2020-10-26 14:10:56.604318949 +0800
@@ -6,8 +6,8 @@
     container_name: drawio
     restart: unless-stopped
     ports:
-      - 8080:8080
-      - 8443:8443
+      - 19099:8080
+      - 19449:8443
     environment:
       PUBLIC_DNS: domain
       ORGANISATION_UNIT: unit
@@ -16,9 +16,8 @@
       STATE: state
       COUNTRY_CODE: country
     healthcheck:
-      test: ["CMD-SHELL", "curl -f http://domain:8080 || exit 1"]
+      test: ["CMD-SHELL", "curl -f http://domain:9090 || exit 1"]
       interval: 1m30s
       timeout: 10s
       retries: 5
-      start_period: 10s
 
EOF

# make patch file, new create docker-compose-b.yml based on docker-compose.yml,then execute
#diff -Naur docker-compose.yml docker-compose-b.yml > docker-compose.patch
# patch for docker-compose.yml 
if [ -f docker-compose.yml ]; then
    patch -p0 < docker-compose.patch
else
    echo "docker-compose.yml file is no exist!"
    rm docker-compose.patch
    exit 1
fi
rm docker-compose.patch

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
