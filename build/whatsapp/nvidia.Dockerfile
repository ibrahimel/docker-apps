# whatsapp web interface using Electron in a container

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

COPY whatsapp.png /usr/share/icons/

RUN npm install -g nativefier

#COPY ./electron /opt/whatsapp

ENV HOME /home/whatsapp
RUN useradd --create-home --home-dir $HOME whatsapp \
	&& usermod -a -G audio,video whatsapp \
	&& chown -R whatsapp:whatsapp $HOME

#RUN su whatsapp -c "cd /opt/whatsapp && npm install && cd node_modules/electron && npm install"

RUN sh -c 'cd /opt && nativefier -i /usr/share/icons/whatsapp.png --name="whatsapp" "https://web.whatsapp.com"'


COPY entrypoint.sh /usr/bin/entrypoint.sh

#RUN chown root /opt/whatsapp/node_modules/electron/dist/chrome-sandbox && chmod 4755 /opt/whatsapp/node_modules/electron/dist/chrome-sandbox

USER whatsapp
WORKDIR $HOME

ENTRYPOINT [ "entrypoint.sh" ]