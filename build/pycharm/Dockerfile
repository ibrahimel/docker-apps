# PyCharm in a container

FROM ubuntu
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	openjdk-11-jre \
	gnupg \
	tar \
	git \
	wget \
	--no-install-recommends

RUN wget -O /tmp/pycharm.tar.gz "https://download-cf.jetbrains.com/python/pycharm-community-2019.1.3.tar.gz"

RUN apt-get update && apt-get install -y \
	python3 \
	python \
	python-pip \
	python3-pip \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN tar xvfz /tmp/pycharm.tar.gz -C /opt/ && rm /tmp/pycharm.tar.gz

ENV HOME /home/pycharm
RUN useradd --create-home --home-dir $HOME pycharm \
	&& gpasswd -a pycharm audio \
	&& chown -R pycharm:pycharm $HOME

WORKDIR $HOME
USER pycharm

# Autorun PyCharm
ENTRYPOINT [ "/opt/pycharm-community-2019.1.3/bin/pycharm.sh" ]
