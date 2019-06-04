# Steam in a container

FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update \
    && apt-get install -y steam \
    && apt-get install -y --reinstall ca-certificates

ENV HOME /home/steam
RUN useradd --create-home --home-dir $HOME steam \
	&& chown -R steam:steam $HOME

WORKDIR $HOME
USER steam

ENTRYPOINT [ "/usr/games/steam" ]
