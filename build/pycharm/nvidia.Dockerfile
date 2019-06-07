# PyCharm in a container

FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	dirmngr \
	gnupg \
	git \
	tar \
	wget \
	libcanberra-gtk-module \
	libcanberra-gtk3-module \
	libx11-xcb1 \
	libxtst6 \
	libnotify4 \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libatomic1 \
	libc++1 \
	libappindicator1 \
	xdg-utils \
	libpulse0 \
	apulse \
	locales \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
	&& locale-gen en_US.UTF-8 \
	&& localedef -i en_US -f UTF-8 en_US.UTF-8 \
	&& dpkg-reconfigure locales

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

RUN wget -O /tmp/pycharm.tar.gz "https://download-cf.jetbrains.com/python/pycharm-community-2019.1.3.tar.gz"

RUN apt update && apt install -y \
	openjdk-8-jre \
	openjdk-11-jre \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y \
	python3 \
	python \
	python-pip \
	python3-pip \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN tar xvfz /tmp/pycharm.tar.gz -C /opt/ && rm /tmp/pycharm.tar.gz

RUN apt update && apt install -y \
	openssh-client \
	ssh-askpass-gnome \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/pycharm
RUN useradd --create-home --home-dir $HOME pycharm \
	&& gpasswd -a pycharm audio \
	&& chown -R pycharm:pycharm $HOME

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR $HOME
USER pycharm

# Autorun PyCharm
ENTRYPOINT [ "entrypoint.sh" ]
