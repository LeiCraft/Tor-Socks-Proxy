#!/bin/bash

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

/usr/bin/socks5-relay -c /home/container/socks-relay-config.json &

exec /usr/bin/tor -f /etc/tor/torrc


