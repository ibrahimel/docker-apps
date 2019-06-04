# ProtonVPN in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

#RUN apt-get update && apt-get install -y \
#	openvpn \
#	--no-install-recommends \
#	&& rm -rf /var/lib/apt/lists/*

FROM alpine:latest
MAINTAINER Colin Hebert <hebert.colin@gmail.com>

RUN apk add --no-cache openvpn

COPY ovpn /ovpn
WORKDIR /ovpn

COPY entrypoint.sh /usr/bin/start-container
ENTRYPOINT [ "start-container" ]
