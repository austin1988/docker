FROM codercom/code-server

USER root
# combine one layer
RUN groupadd -g 1003 software \
 && useradd -u 1002 -g software -m -d /home/wangzy --shell /bin/bash -p wangzy wangzy

USER wangzy
WORKDIR /home/wangzy/workspace
# because /data/arm-gcc-8.2.0 is not exist, so below is invalid
#RUN ["sh", "-c", ".", "/data/arm-gcc-8.2.0/environment-setup-armv7at2hf-neon-tdx-linux-gnueabi"]
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "/home/wangzy"]

