# Visual Studio code-insiders in a container

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

# Add the vscode-insiders debian repo
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | apt-key add -
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode-insiders.list

RUN apt update && apt -y install \
	openssh-client \
	ssh-askpass-gnome \
	python-all \
	python3-all \
	golang \
	nodejs \
	npm \
	rustc \
	cargo \
	libxss1 \
	libnss3 \
	code-insiders \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/code-insiders
RUN useradd --create-home --home-dir $HOME code-insiders \
	&& chown -R code-insiders:code-insiders $HOME

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR $HOME

USER code-insiders

ENTRYPOINT	[ "entrypoint.sh" ]
