FROM    ubuntu

LABEL	maintainer="Rizal Fauzie Ridwan <rizal@fauzie.my.id>"
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/
ENV     PHP_VERSION=7.3 \
        VIRTUAL_HOST=$DOCKER_HOST \
        HOME=/var/www/whmcs \
        PUID=1000 \
        PGID=1000 \
        TZ=Europe/Prague \
        WHMCS_SERVER_IP=172.17.0.1 \
        REAL_IP_FROM=172.17.0.0/16 \
        SSH_PORT=2222

COPY    build /build
RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer / && build/setup.sh && rm -rf /build

COPY    root/ /

RUN     chmod -v +x /etc/my_init.d/*.sh /etc/service/*/run
RUN apt-get update && \
    apt-get install -y nginx && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE  2222

VOLUME  /var/www/whmcs
WORKDIR /var/www/whmcs
ENTRYPOINT ["/init"]
CMD ["nginx"]

