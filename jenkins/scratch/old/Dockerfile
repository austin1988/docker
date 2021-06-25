FROM jenkins/jenkins:lts
USER root
WORKDIR /var/jenkins_home
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y python3 \
    && apt-get install -y python3-pip \
    && apt-get install -y zip
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y subversion \
    && apt-get install -y cppcheck
RUN pip3 install python-jenkins \
    && pip3 install pandas \
    && pip3 install protobuf
