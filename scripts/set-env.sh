#!/bin/sh

SCRIPT_DIR=$(cd `dirname $0`; pwd)
WORK_DIR=$(pwd)
BUILD_DIR=$WORK_DIR

log_file=run.log
current_user=$(id -un)
base_image_name=

if [ $# -gt 0 ] && [ ! -z $1 ]; then
    base_image_name=$1
else
    echo "$0 base_image_name"
    echo "you must special a base_image_name"
    exit 1
fi
image_name="${base_image_name##*/}" # strip repo name, such as codercom/code-server
image_name="${image_name%:*}" # strip tag name, such as codercom/code-server:1.0

# default value
container_name=`basename $WORK_DIR`
container_name="${container_name}-container-$current_user"
#container_name="${image_name}-container-$current_user"
image_name="${image_name}-${current_user}"
#image_count=`docker images --format 'table {{.Repository}}\t{{.Size}}' | grep $image_name | wc -l`
image_count=`docker images --format 'table {{.Repository}}:{{.Tag}}' | grep $image_name | wc -l`
container_count=`docker ps -a -f name=$container_name | grep $container_name | wc -l`

if [ $image_count -eq 1 ]; then
    # image is exist
    $SCRIPT_DIR/gene-yml.sh $image_name $container_name > docker-compose.yml  
else
    BUILD_DIR=$WORK_DIR/build
    if [ ! -d $BUILD_DIR ]; then
        echo "$BUILD_DIR is no exist, it will to be create it"
        mkdir -p $BUILD_DIR
    fi

    $SCRIPT_DIR/gene-Dockerfile.sh $base_image_name > $BUILD_DIR/Dockerfile
    $SCRIPT_DIR/gene-yml.sh $image_name $container_name > $BUILD_DIR/docker-compose.yml  
fi

if [ ! -d $BUILD_DIR/workspace ]; then
    mkdir $BUILD_DIR/workspace
fi

cd $BUILD_DIR/
docker-compose up -d --no-recreate
if [ $? -ne 0 ]; then
    echo "creat container $container_name failed!" >> $log_file
else
    echo "container $container_name has been created success!" >> $log_file
fi

docker exec -ti $container_name /bin/bash
echo "you are in container $container_name" >> $log_file
docker_run_pid=$$
wait $docker_run_pid
echo $docker_run_pid >> $log_file

docker-compose down --volumes
if [ $? -ne 0 ]; then
    echo "destory container $container_name failed!" >> $log_file
else
    echo "container $container_name has been destoryed success!" >> $log_file
fi

#docker rmi $image_name
echo "delete image $image_name finish!" >> $log_file
rm -rf Dockerfile

