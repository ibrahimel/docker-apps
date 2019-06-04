# Android Studio in a container

FROM ubuntu
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	openjdk-11-jre \
	gnupg \
	tar \
	git \
	wget \
	--no-install-recommends

RUN wget -O /tmp/android.tar.gz "https://dl.google.com/dl/android/studio/ide-zips/3.4.1.0/android-studio-ide-183.5522156-linux.tar.gz"

RUN tar xvfz /tmp/android.tar.gz -C /opt/ && rm /tmp/android.tar.gz

ENV HOME /home/android-studio
RUN useradd --create-home --home-dir $HOME android-studio \
	&& gpasswd -a android-studio audio \
	&& chown -R android-studio:android-studio $HOME

WORKDIR $HOME
USER android-studio

# Autorun Android studio
ENTRYPOINT [ "/opt/android-studio/bin/studio.sh" ]
