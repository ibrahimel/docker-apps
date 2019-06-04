# Discord in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	gnupg \
	wget \
	--no-install-recommends

RUN apt-get update && apt-get install -y \
	gconf2 \
	gconf-service \
	gvfs-bin \
	libasound2 \
	libcap2 \
	libgconf-2-4 \
	libgtk2.0-0 \
	libnotify4 \
	libnss3 \
	libpulse0 \
	apulse \
	libxkbfile1 \
	libxss1 \
	libxtst6 \
	libx11-xcb-dev \
	xdg-utils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
	libatomic1 \
	libc++1 \
	libappindicator1 \
	libgtk-3-0 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/discord.deb "https://dl.discordapp.net/apps/linux/0.0.9/discord-0.0.9.deb"

RUN dpkg -i /tmp/discord.deb && rm /tmp/discord.deb

ENV HOME /home/discord
RUN useradd --create-home --home-dir $HOME discord \
	&& gpasswd -a discord audio \
	&& chown -R discord:discord $HOME

WORKDIR $HOME
USER discord

# Autorun discord
ENTRYPOINT [ "discord" ]
