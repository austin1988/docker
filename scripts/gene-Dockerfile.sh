#!/bin/sh

current_user=$(id -un)
current_user_id=$(id -u)
current_group=$(id -gn)
current_group_id=$(id -g)
current_dir=$(pwd)

image_name=

if [ $# -gt 0 ] && [ ! -z $1 ]; then
    image_name=$1
else
    echo "$0 base_image_name"
    echo "you must special a base_image_name"
    exit 1
fi

# failed
if [ -f /usr/share/zoneinfo/Asia/Shanghai ]; then
SET_TIMEZONE="
ENV TimeZone=Asia/Shanghai
RUN cp /usr/share/zoneinfo/\$TimeZone /etc/localtime && echo \$TimeZone > /etc/timezone 
"
fi

cat << EOF
FROM $image_name

USER root

# add user
RUN groupadd -g $current_group_id $current_group \\
 && useradd -u $current_user_id -g $current_group -m -d /home/$current_user --shell /bin/bash -p $current_user $current_user

USER $current_user
WORKDIR /home/$current_user/workspace

EOF
