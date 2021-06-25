FROM nginx:latest
USER root
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y python3 \
    && apt-get install -y python3-pip
RUN pip3 install gunicorn \
    && pip3 install flask
