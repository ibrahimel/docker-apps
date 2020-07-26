# Sublime-text in a container

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

RUN curl -sSL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list

RUN apt update && apt -y install \
	sublime-text \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y \
	openssh-client \
	ssh-askpass-gnome \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/sublime
RUN useradd --create-home --home-dir $HOME sublime \
	&& gpasswd -a sublime audio \
	&& chown -R sublime:sublime $HOME

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR $HOME
USER sublime

ENTRYPOINT ["entrypoint.sh"]
