#!/bin/bash

docker run -p 3306:3306 --name goploy zhenorzz/goploy
docker run --rm \
    -p 3000:80 \
    -v /path/to/.ssh:/root/.ssh \
    -v /path/to/hosts:/etc/hosts \
    -e MYSQL_HOST=mysql \
    -e MYSQL_USER=root \
    -e MYSQL_PASSWORD=password \
    zhenorzz/goploy
