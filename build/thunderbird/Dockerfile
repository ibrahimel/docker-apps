# Thunderbird in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	dirmngr \
	gnupg \
	wget \
	--no-install-recommends \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0AB215679C571D1C8325275B9BDB3D89CE49EC21 \
	&& echo "deb http://ppa.launchpad.net/mozillateam/thunderbird-next/ubuntu xenial main" >> /etc/apt/sources.list.d/firefox.list \
	&& apt-get update && apt-get install -y \
	ca-certificates \
	thunderbird \
	hicolor-icon-theme \
	fonts-noto \
	fonts-noto-cjk \
	fonts-noto-color-emoji \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/thunderbird
RUN useradd --create-home --home-dir $HOME thunderbird \
	&& chown -R thunderbird:thunderbird $HOME

ENV LANG en_US.UTF-8

WORKDIR $HOME

USER thunderbird

ENTRYPOINT [ "thunderbird" ]
