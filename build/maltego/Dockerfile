# Maltego in a container

FROM ubuntu
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	openjdk-8-jre \
	gnupg \
	tar \
	wget \
	--no-install-recommends

RUN wget -O /tmp/maltego.deb "https://www.paterva.com/malv423/Maltego.v4.2.3.12223.deb"

RUN dpkg -i /tmp/maltego.deb && rm /tmp/maltego.deb

ENV HOME /home/maltego
RUN useradd --create-home --home-dir $HOME maltego \
	&& chown -R maltego:maltego $HOME

WORKDIR $HOME
USER maltego

# Autorun Maltego
ENTRYPOINT [ "maltego" ]
