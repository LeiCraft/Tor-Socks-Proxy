FROM debian:12-slim

LABEL org.opencontainers.image.authors="LeiCraft_ <leicraft@leicraftmc.de>"

RUN apt update && \
    apt upgrade -y && \
    apt install -y tor obfs4proxy curl unzip

RUN adduser --disabled-password --home /home/container container && \
    chown -R container /var/lib/tor && chmod 700 /var/lib/tor && \
    rm -rf /var/lib/apt/lists/* && \
    tor --version

COPY --chown=container torrc /etc/tor/

USER container

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./docker-healthcheck.sh /docker-healthcheck.sh

HEALTHCHECK --timeout=10s --start-period=60s \
    CMD /docker-healthcheck.sh || exit 1

EXPOSE 8853/udp 9150/tcp

CMD ["/bin/sh", "/docker-entrypoint.sh"]