# Spotify in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN	apt-get update && apt-get install -y \
	dirmngr \
	gnupg \
	--no-install-recommends \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90 \
	&& echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list.d/spotify.list \
	&& apt-get update && apt-get install -y \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libpulse0 \
	apulse \
	spotify-client \
	xdg-utils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/spotify
RUN useradd --create-home --home-dir $HOME spotify \
	&& gpasswd -a spotify audio \
	&& chown -R spotify:spotify $HOME

WORKDIR $HOME
USER spotify

ENTRYPOINT	[ "spotify" ]
