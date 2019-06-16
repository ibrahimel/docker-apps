# crossover in a container

FROM ubuntu:18.04
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

RUN wget -O /tmp/crossover.deb "https://media.codeweavers.com/pub/crossover/cxlinux/demo/crossover_18.5.0-1.deb"

RUN dpkg --add-architecture i386
RUN apt update \
    && apt install -y /tmp/crossover.deb \
    && apt install -y libxcomposite1 \
	libxml2 \
	libsane \
	libxcomposite1:i386 \
	libxml2:i386 \
	libsane:i386

ENV HOME /home/crossover
RUN useradd --create-home --home-dir $HOME crossover \
	&& chown -R crossover:crossover $HOME

WORKDIR $HOME
USER crossover

ENTRYPOINT [ "/opt/cxoffice/bin/crossover" ]
