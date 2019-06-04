# whatsapp in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	gnupg \
	wget \
	--no-install-recommends

RUN apt-get update && apt-get install -y \
	gconf2 \
	gconf-service \
	gvfs-bin \
	libasound2 \
	libcap2 \
	libgconf-2-4 \
	libgtk2.0-0 \
	libpulse0 \
	apulse \
	libnotify4 \
	libnss3 \
	libxkbfile1 \
	libxss1 \
	libxtst6 \
	libx11-xcb-dev \
	xdg-utils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
	libatomic1 \
	libc++1 \
	libappindicator1 \
	libcanberra-gtk-module \
	libcanberra-gtk3-module \
	libcanberra-gtk0 \
	libcanberra-pulse \
	libcanberra-gtk3-0 \
	libgtk-3-0 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/whatsapp.deb "https://zerkc.gitlab.io/whatsdesk/whatsdesk_0.2.18_amd64.deb"

RUN dpkg -i /tmp/whatsapp.deb && rm /tmp/whatsapp.deb

ENV HOME /home/whatsapp
RUN useradd --create-home --home-dir $HOME whatsapp \
	&& gpasswd -a whatsapp audio \
	&& chown -R whatsapp:whatsapp $HOME

WORKDIR $HOME
USER whatsapp

# Autorun whatsapp
ENTRYPOINT [ "/opt/whatsdesk/whatsdesk" ]
