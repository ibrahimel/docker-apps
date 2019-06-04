# Sublime-text in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get -y install \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	locales \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
	locale-gen && \
	echo "LANG=en_US.UTF-8" > /etc/locale.conf

RUN curl -sSL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list

RUN apt-get update && apt-get -y install \
	libcanberra-gtk-module \
	sublime-text \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/sublime
RUN useradd --create-home --home-dir $HOME sublime \
	&& gpasswd -a sublime audio \
	&& chown -R sublime:sublime $HOME

WORKDIR $HOME
USER sublime

COPY start.sh /usr/local/bin/start.sh

ENTRYPOINT ["start.sh"]
