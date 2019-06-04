# Transmission in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

# Install transmission and its dependencies
RUN apt-get update && apt-get install -y \
	transmission-cli \
	transmission-common \
	transmission-daemon \
	transmission-gtk \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/transmission
RUN useradd --create-home --home-dir $HOME transmission \
	&& chown -R transmission:transmission $HOME

ENV LANG en_US.UTF-8

WORKDIR $HOME

USER transmission

# Autorun transmission
CMD ["/usr/bin/transmission-gtk"]
