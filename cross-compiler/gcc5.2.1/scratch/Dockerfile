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
cpio \
"

ARG KERNEL_DEPS_DEBIAN_INSTALL="\
make \
gcc \
libncurses5-dev \
lzop \
cpio \
bc \
"

ARG OTHERS_DEPS_DEBIAN_INSTALL="\
subversion \
file \
python \
unzip \
rsync \ 
"


USER root
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    $YOCTO_DEPS_DEBIAN_INSTALL \
    $KERNEL_DEPS_DEBIAN_INSTALL \
    $OTHERS_DEPS_DEBIAN_INSTALL \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*


