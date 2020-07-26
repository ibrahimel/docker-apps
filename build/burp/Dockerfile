# Burpsuite in a container

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

# burp (free)
RUN wget -O /burp.jar "https://portswigger.net/burp/releases/download?productid=100&version=1.7.36&type=jar"

RUN apt update && apt install -y \
	openjdk-8-jre \
	openjdk-11-jre \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i -e '/^assistive_technologies=/s/^/#/' /etc/java-*-openjdk/accessibility.properties

ENV HOME /home/burp
RUN useradd --create-home --home-dir $HOME burp \
	&& chown -R burp:burp $HOME \
	&& chown burp:burp /burp.jar

WORKDIR $HOME
USER burp

# Autorun Burp
ENTRYPOINT ["java", "-jar", "-Xmx1024m", "/burp.jar"]
