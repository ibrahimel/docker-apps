# typora in a container

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

RUN wget -qO - https://typora.io/linux/public-key.asc | apt-key add - \
	&& echo "deb https://typora.io/linux ./" | tee -a /etc/apt/sources.list.d/typora.list

RUN apt update && apt install -y \
	gconf2 \
	gconf-service \
	gvfs-bin \
	libcap2 \
	libgconf-2-4 \
	libnss3 \
	libxkbfile1 \
	libxss1 \
	libx11-xcb-dev \
	xdg-utils \
	typora \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/typora
RUN useradd --create-home --home-dir $HOME typora \
	&& chown -R typora:typora $HOME

WORKDIR $HOME
USER typora

ENTRYPOINT [ "typora" ]

