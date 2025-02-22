#!/bin/bash

#AUTH=true

TOR_SOCKS_CONF=""

if [ "$AUTH" = true ]; then
  TOR_SOCKS_CONF+="SocksPort 127.0.0.1:9151\n"
  TOR_SOCKS_CONF+="SocksPort [::1]:9151\n"
else
  TOR_SOCKS_CONF+="SocksPort 0.0.0.0:9150\n"
  TOR_SOCKS_CONF+="SocksPort [::]:9150\n"
fi

cat << TORRC > "/home/container/torrc"

HardwareAccel 1
Log notice stdout
DataDirectory /var/lib/tor

DNSPort 0.0.0.0:8853
DNSPort [::]:8853

$(echo -e $TOR_SOCKS_CONF)

TORRC

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
  ],
  "AuthClientInfo": [
    {
      "user": "110",
      "pwd": "123456"
    },
    {
      "user": "111",
      "pwd": "123456"
    }
  ]
}
SOCKS5_CONF

if [ "$AUTH" = true ]; then
  /usr/bin/socks5-relay -c /home/container/socks-relay-config.json &
fi

exec /usr/bin/tor -f /home/container/torrc


