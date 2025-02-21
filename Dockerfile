FROM debian:12-slim

LABEL org.opencontainers.image.authors="LeiCraft_ <leicraft@leicraftmc.de>"

RUN apt update && \
    apt upgrade -y && \
    apt install -y tor obfs4proxy curl unzip

RUN curl -L -o /tmp/socks5balancer.zip \
    https://github.com/Socks5Balancer/Socks5BalancerAsio/releases/download/v1.3.6-fix/Socks5BalancerAsio-e0a05953f1989bc3d7cbf776f2e88832fd313259-DynamicSSL-ProxyHandshakeAuth-Linux.zip && \
    unzip /tmp/socks5balancer.zip -d /tmp/socks5-relay && \
    mv /tmp/socks5-relay/Socks5BalancerAsio /usr/bin/socks5-relay && \
    chmod 755 /usr/bin/socks5-relay && \
    rm -rf /tmp/socks5balancer.zip /tmp/socks5-relay

RUN adduser --disabled-password --home /home/container container && \
    chown -R container /var/lib/tor && chmod 700 /var/lib/tor && \
    rm -rf /var/lib/apt/lists/* && \
    tor --version

USER container

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./docker-healthcheck.sh /docker-healthcheck.sh

HEALTHCHECK --timeout=10s --start-period=60s \
    CMD /docker-healthcheck.sh || exit 1

EXPOSE 8853/udp 9150/tcp

CMD ["/bin/sh", "/docker-entrypoint.sh"]