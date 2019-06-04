# Qbittorrent in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

# Install transmission and its dependencies
RUN apt-get update && apt-get install -y \
	qbittorrent \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/qbittorrent
RUN useradd --create-home --home-dir $HOME qbittorrent \
	&& chown -R qbittorrent:qbittorrent $HOME

ENV LANG en_US.UTF-8

WORKDIR $HOME

USER qbittorrent

# Autorun transmission
CMD ["qbittorrent"]
