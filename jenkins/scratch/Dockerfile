FROM jenkins/jenkins:lts

USER root

# ubuntu components
ARG JENKIS_PYTHON_API_DEPS_DEBIAN_INSTALL="\
python3 \
python3-pip \
zip \
subversion \
"

ARG KERNEL_DEPS_DEBIAN_INSTALL="\
bc \
"

ARG CPPCHECK_DEPS_DEBIAN_INSTALL="\
cppcheck \
"

# python modules
# python-jenkins maybe fail , you must step into container manaul pip3 install setuptools
#python-jenkins \
ARG JENKIS_PYTHON_API_DEPS_PIP_INSTALL="\
pandas \
protobuf \
"

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    $JENKIS_PYTHON_API_DEPS_DEBIAN_INSTALL \
    $KERNEL_DEPS_DEBIAN_INSTALL \
    $CPPCHECK_DEPS_DEBIAN_INSTALL \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

RUN pip3 install \
    $JENKIS_PYTHON_API_DEPS_PIP_INSTALL

WORKDIR /var/jenkins_home

