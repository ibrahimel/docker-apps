# Firefox in a container

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

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0AB215679C571D1C8325275B9BDB3D89CE49EC21 \
	&& echo "deb http://ppa.launchpad.net/mozillateam/firefox-next/ubuntu bionic main" >> /etc/apt/sources.list.d/firefox.list \
	&& apt update && apt install -y \
	ffmpeg \
	firefox \
	libu2f-host0 \
	libpam-yubico \
	libyubikey0 \
	python-yubico \ 
	fonts-noto \
	fonts-noto-cjk \
	fonts-noto-color-emoji \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/firefox
RUN useradd --create-home --home-dir $HOME firefox \
	&& gpasswd -a firefox audio && gpasswd -a firefox video \
	&& chown -R firefox:firefox $HOME

COPY local.conf /etc/fonts/local.conf
RUN echo 'pref("browser.tabs.remote.autostart", false);' >> /etc/firefox/syspref.js
RUN echo 'pref("browser.tabs.remote.autostart.2", false);' >> /etc/firefox/syspref.js

WORKDIR $HOME
USER firefox

ENTRYPOINT [ "firefox", "--no-remote" ]
