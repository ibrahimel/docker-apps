# OpenVPN Client in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

FROM alpine:latest

RUN apk add --no-cache openvpn

COPY ovpn /ovpn
COPY iptables.rules /

WORKDIR /ovpn

COPY entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
