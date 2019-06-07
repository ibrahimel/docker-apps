#!/bin/sh
set -e -u -o pipefail

iptables-restore < /iptables.rules

sleep 1

VPN_USERNAME="fakeuser"
VPN_PASSWORD="fakepass"

REGION=$(find ./ -name *.ovpn | shuf -n 1)

if [ -n "$REGION" ]; then
  set -- "$@" '--config' "${REGION}"
fi

if [ -n "$VPN_USERNAME" -a -n "$VPN_PASSWORD" ]; then
  echo "$VPN_USERNAME" > auth.conf
  echo "$VPN_PASSWORD" >> auth.conf
  set -- "$@" '--auth-user-pass' 'auth.conf'
fi

openvpn "$@"
