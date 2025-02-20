#!/bin/bash

GH_BASE_URL="https://github.com/Socks5Balancer/Socks5BalancerAsio/releases/download/v1.3.6-fix/Socks5BalancerAsio-e0a05953f1989bc3d7cbf776f2e88832fd313259"

#DOWNLOAD_URL="$GH_BASE_URL-DynamicSSL-ProxyHandshakeAuth-Linux.zip"
DOWNLOAD_URL="$GH_BASE_URL-DynamicSSL-Normal-Linux.zip"

HOME_DIR="/home/container"
TMP_DIR="$HOME_DIR/tmp"
SOCKS5_RELAY_BIN="$HOME_DIR/socks5-relay"

mkdir -p $TMP_DIR && \
curl -L -o $TMP_DIR/socks5balancer.zip $DOWNLOAD_URL && \
    unzip $TMP_DIR/socks5balancer.zip -d $TMP_DIR/socks5-relay && \
    mv $TMP_DIR/socks5-relay/Socks5BalancerAsio "$SOCKS5_RELAY_BIN" && \
    chmod 755 "$SOCKS5_RELAY_BIN" && \
    rm -rf $TMP_DIR/socks5balancer.zip $TMP_DIR/socks5-relay

cat << SOCKS5_CONF > "/home/container/socks-relay-config.json"

{
  "listenHost": "::",
  "listenPort": 9150,
  "upstreamSelectRule": "random",
  "serverChangeTime": 5000,
  "upstream": [
    {
      "host": "127.0.0.1",
      "port": 9151
    }
  ]
}

SOCKS5_CONF

/home/container/socks5-relay -c /home/container/socks-relay-config.json &

exec /usr/bin/tor -f /etc/tor/torrc


