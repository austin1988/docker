#!/bin/sh

usage()
{
    echo "Usage:"
    echo "$1 <action> [container name]"
    echo "action: "
    echo "       list | start | stop | in"
}

if [ $# -eq 1 ];then
    if [ "$1" = "list" ];then
        echo "images: "
        docker images
        echo ""
        echo "containers: "
        docker ps -a 
    else
        usage $0
    fi
    exit 0
fi

if [ $# -lt 2 ];then
    usage $0
    exit 0
fi

ACTION=$1
CONTAINER_NAME=$2
PROJECT_DIR=$CONTAINER_NAME
if [ "$CONTAINER_NAME" = "jenkins" ];then
    CONTAINER_NAME="jenkins-container" 
    PROJECT_DIR=jenkins/jenkins
elif [ "$CONTAINER_NAME" = "build" ];then
    CONTAINER_NAME="jenkins-build-container" 
    PROJECT_DIR=jenkins/build
elif [ "$CONTAINER_NAME" = "cppcheck" ];then
    CONTAINER_NAME="jenkins-cppcheck-container" 
    PROJECT_DIR=jenkins/cppcheck
elif [ "$CONTAINER_NAME" = "ramdisk" ];then
    PROJECT_DIR=cross-compiler/gcc8.2.0
elif [ "$CONTAINER_NAME" = "arm-gcc5" ];then
    PROJECT_DIR=cross-compiler/gcc5.2.1
elif [ "$CONTAINER_NAME" = "toradexBSP3.0" ];then
    PROJECT_DIR=yocto/linuxImageV3.0
elif [ "$CONTAINER_NAME" = "bitbake" ];then
    PROJECT_DIR=yocto/bitbake-environment
elif [ "$CONTAINER_NAME" = "boot2qt" ];then
    PROJECT_DIR=yocto/boot2qt-5.13.2
elif [ "$CONTAINER_NAME" = "boot2qt-12" ];then
    PROJECT_DIR=yocto/boot2qt-5.12.3-maybe
fi

if [ ! -d $PROJECT_DIR ];then
    echo "$PROJECT_DIR is no exist, please check container name $CONTAINER_NAME" 
    exit 1
fi

if [ "$ACTION" = "start" ];then
    cd $PROJECT_DIR 
    docker-compose up -d
    cd -
elif [ "$ACTION" = "stop" ];then
    cd $PROJECT_DIR 
    docker-compose down
    cd -
elif [ "$ACTION" = "in" ];then
    cd $PROJECT_DIR 
    if [ "$CONTAINER_NAME" = "ramdisk" ] \
    || [ "$CONTAINER_NAME" = "arm-gcc5" ];then
        ./set-env.sh ubuntu18.04-yocto:1.0
    elif [ "$CONTAINER_NAME" = "toradexBSP3.0" ] \
    || [ "$CONTAINER_NAME" = "bitbake" ] \
    || [ "$CONTAINER_NAME" = "boot2qt" ] \
    || [ "$CONTAINER_NAME" = "boot2qt-12" ];then
        ./scripts/set-env.sh ubuntu16.04-yocto:1.0
    else
        docker exec -ti $CONTAINER_NAME /bin/bash
    fi
    cd -
fi
