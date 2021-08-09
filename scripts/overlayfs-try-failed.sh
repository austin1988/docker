#!/bin/sh

PWD_DIR=`pwd`
WORK_DIR="`id -u`-work"


cd $PWD_DIR
mkdir $WORK_DIR
mkdir $WORK_DIR/download

sudo mount -t overlay overlay -o lowerdir=/data/toradex/LinuxImageV2.6,upperdir=wangzy-work,workdir=tmp-work wangzy-work
docker exec -i ubuntu16.04 mount -t overlay overlay -o lowerdir=/data/toradex/LinuxImageV2.6,upperdir=/home/wangzy/wangzy-work/yocto,workdir=/home/wangzy/wangzy-work/work /home/wangzy/wangzy-work/yocto
docker exec -i ubuntu16.04 mkdir /home/wangzy/wangzy-work
docker exec -i ubuntu16.04 mkdir /home/wangzy/wangzy-work/work
docker exec -i ubuntu16.04 mkdir /home/wangzy/wangzy-work/yocto
