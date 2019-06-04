#!/bin/sh
set -e -u -o pipefail

VPN_USERNAME=""
VPN_PASSWORD=""

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
