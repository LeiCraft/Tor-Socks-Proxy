FROM alpine:3.21

LABEL org.opencontainers.image.authors="LeiCraft_ <leicraft@leicraftmc.de>"

RUN echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/testing'   >> /etc/apk/repositories && \
    apk -U upgrade && \
    apk -v add tor@edge obfs4proxy@edge curl && \
    chmod 700 /var/lib/tor && \
    rm -rf /var/cache/apk/* && \
    tor --version

COPY --chown=tor:root torrc /etc/tor/

USER tor

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./docker-healthcheck.sh /docker-healthcheck.sh

HEALTHCHECK --timeout=10s --start-period=60s \
    CMD /docker-healthcheck.sh || exit 1

EXPOSE 8853/udp 9150/tcp

CMD ["/bin/sh", "/docker-entrypoint.sh"]