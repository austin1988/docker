#!/bin/sh


docker_containers=`docker ps -a --format 'table {{.Names}}'`


    docker inspect --format='{{.Name}} - {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)
for item in $docker_containers
do
    #docker inspect $item | grep -A3 "Gateway"
    #docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $item
    :
done

# clear all unused network
# docker network prune
