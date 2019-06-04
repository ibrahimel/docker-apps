# 	docker cp virtualbox:/usr/lib/virtualbox /usr/lib
# 	docker cp virtualbox:/usr/share/virtualbox /usr/share
# 	/usr/lib/virtualbox/vboxdrv.sh setup
# 	rm -rf /usr/share/virtualbox /usr/lib/virtualbox
#
# Virtualbox in a container

FROM debian:stretch-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	libcurl3 \
	libvpx4 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN buildDeps=' \
		ca-certificates \
		curl \
		gnupg \
	' \
	&& set -x \
	&& mkdir -p /etc/xdg/QtProject \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -sSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | apt-key add - \
	&& echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" >> /etc/apt/sources.list.d/virtualbox.list \
	&& apt-get update && apt-get install -y \
	virtualbox-5.2 \
	--no-install-recommends \
	&& apt-get purge -y --auto-remove $buildDeps

ENV HOME /home/virtualbox
RUN useradd --create-home --home-dir $HOME virtualbox \
	&& chown -R virtualbox:virtualbox $HOME \
	&& usermod -a -G audio,video virtualbox

ENV LANG en_US.UTF-8

WORKDIR $HOME

USER virtualbox

ENTRYPOINT	[ "/usr/bin/virtualbox" ]
