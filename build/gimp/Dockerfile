# Gimp in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	gimp \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/gimp
RUN useradd --create-home --home-dir $HOME gimp \
	&& chown -R gimp:gimp $HOME

WORKDIR $HOME
USER gimp

ENTRYPOINT [ "gimp" ]
