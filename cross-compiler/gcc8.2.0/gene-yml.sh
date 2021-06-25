#!/bin/sh

current_user=$(id -un)
current_user_id=$(id -u)
current_group=$(id -gn)
current_group_id=$(id -g)
current_dir=$(pwd)
container_name=
if [ $# -gt 0 ] && [ ! -z $1 ]; then
    image_name=$1
else
    # default value
    image_name=`basename $current_dir`
    image_name="${image_name}-$current_user"
fi

if [ $# -gt 0 ] && [ ! -z $2 ]; then
    container_name=$2
else
    # default value
    container_name=`basename $current_dir`
    container_name="${container_name}-container-$current_user"
fi

server_name=$image_name

cat << EOF
version: '2'
services:
  $server_name:
    build: .
    image: $image_name
    container_name: $container_name
    restart: unless-stopped
    volumes:
      - "/etc/timezone:/etc/timezone"
      - "/etc/localtime:/etc/localtime"
      - "./workspace:/home/$current_user/workspace"
      - "/data/arm-gcc-8.2.0:/data/arm-gcc-8.2.0"
    command:
      - /bin/bash
    cap_add:
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    user: $current_user
    stdin_open: true
    tty: true

EOF

