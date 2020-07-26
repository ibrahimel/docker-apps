FROM ubuntu:16.04

RUN apt-get update && apt-get install -y apt-transport-https

ARG indy_stream=master

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88
RUN echo "deb https://repo.sovrin.org/sdk/deb xenial $indy_stream" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y indy-cli libindy python3 python3-pip nano --allow-unauthenticated

RUN python3 -m pip install python3-indy

ENV HOME /home/indy
RUN useradd --create-home --home-dir $HOME indy \
	&& gpasswd -a indy sudo \
	&& echo 'indy ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
	&& chown -R indy:indy $HOME
	
WORKDIR $HOME
USER indy

COPY indy-sdk /home/indy/indy-sdk

# Autorun bash
ENTRYPOINT [ "bash" ]
