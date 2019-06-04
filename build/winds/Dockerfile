# winds in a container

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
	libnotify4 \
	libnss3 \
	libpulse0 \
	apulse \
	libxkbfile1 \
	libxss1 \
	libxtst6 \
	libx11-xcb-dev \
	xdg-utils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
	libgtk-3-0 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN wget -O /opt/winds "https://s3.amazonaws.com/winds-2.0-releases/releases/Winds%203.1.11.AppImage" && chmod +x /opt/winds && /opt/winds --appimage-extract && rm /opt/winds && mv /opt/squashfs-root /opt/winds

ENV HOME /home/winds
RUN useradd --create-home --home-dir $HOME winds \
	&& gpasswd -a winds audio \
	&& chown -R winds:winds $HOME && chown -R winds:winds /opt/winds

WORKDIR $HOME
USER winds

# Autorun winds
ENTRYPOINT [ "/opt/winds/winds" ]
