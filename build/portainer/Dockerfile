# Portainer in a container

FROM portainer/portainer as base
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

FROM debian:sid-slim

COPY --from=base / /

RUN apt-get update && apt-get install -y \
	npm \
	nodejs\
	git \
	gconf2 \
	gconf-service \
	gvfs-bin \
	libasound2 \
	libcap2 \
	libgconf-2-4 \
	libgtk2.0-0 \
	libgtk-3-0 \
	libnotify4 \
	libnss3 \
	libxkbfile1 \
	libxss1 \
	libxtst6 \
	libx11-xcb-dev \
	xdg-utils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN npm install -g nativefier

COPY portainer.png /usr/share/icons/

VOLUME /data

RUN sh -c "/portainer &" \
	&& sh -c 'cd /opt && nativefier -i /usr/share/icons/portainer.png --name="portainer" "http://localhost:9000"'

WORKDIR /

EXPOSE 9000

COPY entrypoint.sh /usr/bin/start-container
ENTRYPOINT [ "start-container" ]
