# Zoom-us in a container

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

RUN apt update && apt install -y \
	libsm6 \
	libnss3 \
	libxss1 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ARG ZOOM_URL=https://zoom.us/client/latest/zoom_amd64.deb

#install zoom
RUN curl -L $ZOOM_URL -o /tmp/zoom_setup.deb \
	&& apt update && apt install -y /tmp/zoom_setup.deb \
	&& apt -f install \
	&& rm /tmp/zoom_setup.deb \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/zoom-us
RUN useradd --create-home --home-dir $HOME zoom-us \
	&& chown -R zoom-us:zoom-us $HOME \
	&& usermod -a -G audio,video zoom-us

ENV LANG en_US.UTF-8

WORKDIR $HOME

USER zoom-us

ENTRYPOINT [ "/usr/bin/zoom" ]
