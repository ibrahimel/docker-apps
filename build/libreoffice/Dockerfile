# Libreoffice in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	libreoffice \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/libreoffice
RUN useradd --create-home --home-dir $HOME libreoffice \
	&& chown -R libreoffice:libreoffice $HOME

WORKDIR $HOME
USER libreoffice

ENTRYPOINT [ "libreoffice" ]
