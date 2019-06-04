# VLC in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	vlc \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/vlc
RUN useradd --create-home --home-dir $HOME vlc \
	&& chown -R vlc:vlc $HOME \
	&& usermod -a -G audio,video vlc

WORKDIR $HOME
USER vlc

ENTRYPOINT [ "vlc" ]
