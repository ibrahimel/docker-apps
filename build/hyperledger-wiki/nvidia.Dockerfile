# hyperledger-wiki web interface using Electron in a container

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
	npm \
	nodejs\
	libxss1 \
	libnss3 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

COPY hyperledger-wiki.png /usr/share/icons/

COPY ./electron /opt/hyperledger-wiki

ENV HOME /home/hyperledger-wiki
RUN useradd --create-home --home-dir $HOME hyperledger-wiki \
	&& usermod -a -G audio,video hyperledger-wiki \
	&& chown -R hyperledger-wiki:hyperledger-wiki /opt/hyperledger-wiki \
	&& chown -R hyperledger-wiki:hyperledger-wiki $HOME

RUN su hyperledger-wiki -c "cd /opt/hyperledger-wiki && npm install && cd node_modules/electron && npm install"

COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN chown root /opt/hyperledger-wiki/node_modules/electron/dist/chrome-sandbox && chmod 4755 /opt/hyperledger-wiki/node_modules/electron/dist/chrome-sandbox

USER hyperledger-wiki
WORKDIR $HOME

ENTRYPOINT [ "entrypoint.sh" ]

