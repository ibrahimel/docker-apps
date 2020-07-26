# Maltego in a container

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

RUN wget -O /tmp/maltego.deb "https://www.paterva.com/malv423/Maltego.v4.2.3.12223.deb"

RUN dpkg -i /tmp/maltego.deb && rm /tmp/maltego.deb

RUN apt update && apt install -y \
	openjdk-8-jre \
	openjdk-11-jre \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/maltego
RUN useradd --create-home --home-dir $HOME maltego \
	&& chown -R maltego:maltego $HOME

WORKDIR $HOME
USER maltego

# Autorun Maltego
ENTRYPOINT [ "maltego" ]
