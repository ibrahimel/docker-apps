# Geary in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	geary \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/geary
RUN useradd --create-home --home-dir $HOME geary \
	&& chown -R geary:geary $HOME

WORKDIR $HOME
USER geary

ENTRYPOINT [ "geary" ]
