# Evince in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	evince \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/evince
RUN useradd --create-home --home-dir $HOME evince \
	&& chown -R evince:evince $HOME

WORKDIR $HOME
USER evince

ENTRYPOINT [ "evince" ]
