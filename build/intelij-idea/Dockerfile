# InteliJ Idea in a container

FROM ubuntu
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	openjdk-11-jre \
	gnupg \
	tar \
	git \
	wget \
	--no-install-recommends

RUN wget -O /tmp/idea.tar.gz "https://download.jetbrains.com/idea/ideaIC-2019.1.3.tar.gz"

RUN tar xvfz /tmp/idea.tar.gz -C /opt/ && rm /tmp/idea.tar.gz

ENV HOME /home/intelij-idea
RUN useradd --create-home --home-dir $HOME intelij-idea \
	&& gpasswd -a intelij-idea audio \
	&& chown -R intelij-idea:intelij-idea $HOME

WORKDIR $HOME
USER intelij-idea

# Autorun atom
ENTRYPOINT [ "/opt/idea-IC-191.7479.19/bin/idea.sh" ]
