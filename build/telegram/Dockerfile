# telegram in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	gnupg \
	wget \
	--no-install-recommends

RUN apt-get update && apt-get install -y \
	telegram-desktop \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/telegram
RUN useradd --create-home --home-dir $HOME telegram \
	&& gpasswd -a telegram audio \
	&& chown -R telegram:telegram $HOME

WORKDIR $HOME
USER telegram

# Autorun telegram
ENTRYPOINT [ "telegram-desktop" ]
