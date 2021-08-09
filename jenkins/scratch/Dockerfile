FROM jenkins/jenkins:lts

USER root

# ubuntu components
ARG JENKIS_PYTHON_API_DEPS_DEBIAN_INSTALL="\
python \
python-pip \
subversion \
xz-utils \
zip \
"

ARG JENKIS_PYTHON3_API_DEPS_DEBIAN_INSTALL="\
python3 \
python3-pip \
subversion \
xz-utils \
zip \
"

ARG KERNEL_DEPS_DEBIAN_INSTALL="\
make \
gcc \
lzop \
bc \
subversion \
"

ARG CPPCHECK_DEPS_DEBIAN_INSTALL="\
cppcheck \
"

ARG JENKIS_DEPS_DEBIAN_INSTALL="\
$JENKIS_PYTHON3_API_DEPS_DEBIAN_INSTALL \
$KERNEL_DEPS_DEBIAN_INSTALL \
$CPPCHECK_DEPS_DEBIAN_INSTALL \
"

# python modules
# python-jenkins maybe fail , you must step into container manaul pip3 install setuptools
#python-jenkins \
ARG CPPCHECK_DEPS_PIP_INSTALL="\
pandas \
protobuf \
"

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    $JENKIS_DEPS_DEBIAN_INSTALL \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

#RUN pip install \
RUN pip3 install \
    $CPPCHECK_DEPS_PIP_INSTALL

WORKDIR /var/jenkins_home

