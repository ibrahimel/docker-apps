# Virtualbox in a container

#FROM debian:stretch-slim
FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y \
	libcurl3 \
	libvpx5 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN buildDeps=' \
		ca-certificates \
		curl \
		gnupg \
	' \
	&& set -x \
	&& mkdir -p /etc/xdg/QtProject \
	&& apt update && apt install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -sSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | apt-key add - \
	&& echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" >> /etc/apt/sources.list.d/virtualbox.list \
	&& apt update && apt install -y \
	virtualbox-5.2 \
	&& apt purge -y --auto-remove $buildDeps

ENV HOME /home/virtualbox
RUN useradd --create-home --home-dir $HOME virtualbox \
	&& chown -R virtualbox:virtualbox $HOME \
	&& usermod -a -G audio,video virtualbox

ENV LANG en_US.UTF-8

WORKDIR $HOME

USER virtualbox

ENTRYPOINT	[ "/usr/bin/virtualbox" ]
