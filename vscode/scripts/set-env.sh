#!/bin/sh

SCRIPT_DIR=$(cd `dirname $0`; pwd)
WORK_DIR=$(pwd)

log_file=run.log
current_user=$(id -un)
base_image_name=

help_info_msg="
Usage: $0 <option> \n
option: \n
-h: print this help infomation \n
-b: rebuild a container, must with container name \n
-i: step into a container, must with container name \n
-r: stop and remove a container, must with container name \n
"
# function defination
help_info()
{
    echo -e $help_info_msg
}
print_log()
{
    echo "$(date +%F\ %T): $*" | tee -a $WORK_DIR/build.log
}

if [ $# -gt 1 ] && [ ! -z $2 ]; then
    base_image_name=$2
else
    help_info
    #echo "$0 base_image_name"
    #echo "you must special a base_image_name"
    exit 1
fi

image_name="${base_image_name##*/}" # strip repo name, such as codercom/code-server
image_name="${image_name%:*}" # strip tag name, such as codercom/code-server:1.0
container_name="${image_name}-container-$current_user"
image_name="${image_name}-${current_user}"
#image_count=`docker images --format 'table {{.Repository}}\t{{.Size}}' | grep $image_name | wc -l`
image_count=`docker images --format 'table {{.Repository}}:{{.Tag}}' | grep $image_name | wc -l`
container_count=`docker ps -a -f name=$container_name | grep $container_name | wc -l`

if [ $image_count -eq 1 ]; then
    # image is exist
    $SCRIPT_DIR/gene-yml.sh $image_name > docker-compose.yml  
else
    $SCRIPT_DIR/gene-Dockerfile.sh $base_image_name > Dockerfile
    $SCRIPT_DIR/gene-yml.sh $image_name $container_name > docker-compose.yml  
fi

if [ ! -d $WORK_DIR/workspace ]; then
    mkdir $WORK_DIR/workspace
fi

build_container()
{
    docker-compose up -d --no-recreate
    if [ $? -ne 0 ]; then
        echo "creat container $container_name failed!" >> $log_file
    else
        echo "container $container_name has been created success!" >> $log_file
    fi
}

into_container()
{
    docker exec -ti $container_name /bin/bash
    echo "you are in container $container_name" >> $log_file
    #docker_run_pid=$$
    #wait $docker_run_pid
    #echo $docker_run_pid >> $log_file
}

remove_container()
{
    docker-compose down --volumes
    if [ $? -ne 0 ]; then
        echo "destory container $container_name failed!" >> $log_file
    else
        echo "container $container_name has been destoryed success!" >> $log_file
    fi
}

remove_image()
{
    docker rmi $image_name
    echo "delete image $image_name finish!" >> $log_file
    rm -rf Dockerfile
}

# main body
while true
do
    case "$1" in
        -h | --help)
            help_info;
            exit
            ;;
        -b | --rebuild)
            build_container
            #if []; then
            #    print_log "there is no machine $MACHINE_NAME"
            #    help_info;
            #    exit 1
            #fi
            shift 2
            continue
            ;;
        -i | --into)
            into_container
            shift
            continue
            ;;
        -r | --remove)
            remove_image
            shift
            continue
            ;;
        *)
            exit;
            ;;
    esac
done


