# ProtonVPN in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

#RUN apt update && apt install -y \
#	openvpn \
#	--no-install-recommends \
#	&& rm -rf /var/lib/apt/lists/*

FROM alpine:3.5

# Install the required packages
RUN apk add --update tor iptables sudo

# Expose the ports made available through Tor
EXPOSE 9001 9040 9050 5353/udp

# Populate the tor-router configurations
COPY . /opt/tor-router

# Set the container's WORKDIR and ENTRYPOINT
WORKDIR /opt/tor-router
ENTRYPOINT ["/opt/tor-router/entrypoint.sh"]
