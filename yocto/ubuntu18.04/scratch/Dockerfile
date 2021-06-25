FROM ubuntu:18.04

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
bc \
file \
cpio \
"

USER root
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    $YOCTO_DEPS_DEBIAN_INSTALL \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*


