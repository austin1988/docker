FROM ubuntu:20.04

ARG KERNEL_DEPS_DEBIAN_INSTALL="\
libncurses5-dev \
locales \
cpio \
bc \
"

ARG YOCTO_DEPS_DEBIAN_INSTALL="\
locales \
wget \
make \
git \
gawk \
patch \
chrpath \
diffstat \
libxml2-utils \
xsltproc \
texinfo \
libsdl1.2-dev \
gcc \
g++ \
file \
cpio \
"

ARG BUILDROOT_DEPS_DEBIAN_INSTALL="\
libncurses5-dev \
locales \
python \
unzip \
rsync \
cpio \
"

ARG STM32CUBEIDE_DEPS_DEBIAN_INSTALL="\
locales \
libncurses5-dev \
python \
"

USER root

#RUN apt-get -y update && apt-get install -y --no-install-recommends \
#    $YOCTO_DEPS_DEBIAN_INSTALL \
#    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# depend on locales component
#RUN locale-gen en_US.UTF-8

