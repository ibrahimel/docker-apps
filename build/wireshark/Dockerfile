# Wireshark in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	software-properties-common \
	--no-install-recommends && \
	apt-get install -y \
	wireshark \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/wireshark
RUN useradd --create-home --home-dir $HOME wireshark \
	&& chown -R wireshark:wireshark $HOME

RUN chown root:wireshark /usr/bin/dumpcap \
	&& setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap

USER wireshark

WORKDIR wireshark

ENTRYPOINT	[ "wireshark" ]
