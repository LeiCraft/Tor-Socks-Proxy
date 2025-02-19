#!/bin/sh

cat << TOR_CONF > "/etc/tor/torrc"

HardwareAccel 1
Log notice stdout
DataDirectory /var/lib/tor

DNSPort 0.0.0.0:8853
DNSPort [::]:8853

SocksPort 0.0.0.0:9150
SocksPort [::]:9150

TOR_CONF

/usr/bin/tor -f /etc/tor/torrc
