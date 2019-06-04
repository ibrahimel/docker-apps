# Audacity in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	audacity \
	libpulse0 \
	apulse \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/audacity
RUN useradd --create-home --home-dir $HOME audacity \
	&& gpasswd -a audacity audio \
	&& chown -R audacity:audacity $HOME

WORKDIR $HOME
USER audacity

ENTRYPOINT [ "audacity" ]
