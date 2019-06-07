# whatsapp in a container

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

RUN wget -O /tmp/whatsapp.deb "https://zerkc.gitlab.io/whatsdesk/whatsdesk_0.2.18_amd64.deb"

RUN apt update && apt install -y /tmp/whatsapp.deb && rm /tmp/whatsapp.deb

ENV HOME /home/whatsapp
RUN useradd --create-home --home-dir $HOME whatsapp \
	&& gpasswd -a whatsapp audio \
	&& chown -R whatsapp:whatsapp $HOME

WORKDIR $HOME
USER whatsapp

# Autorun whatsapp
ENTRYPOINT [ "/opt/whatsdesk/whatsdesk" ]
