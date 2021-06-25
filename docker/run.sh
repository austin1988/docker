docker run -ti \
-v "/var/run/docker.sock:/var/run/docker.sock" \
--name docker_in_docker docker

# new official
#docker pull mreimbold/ubuntu1804-dind
#docker run --detach --privileged --name docker mreimbold/ubuntu1804-dind:latest
#docker exec -ti docker /bin/bash
#--volume /var/run/docker.sock:/var/run/docker.sock failed
