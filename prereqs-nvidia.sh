#!/bin/bash

# Install pre-requisites for Ubuntu 18.04 + 19.04
# (Nvidia only supports bionic thus the forced bionic below)
# When Nvidia adds suport for cosmic and disco we can use $ubuntu_release ...
# But they will most certainly only support LTS releases ...

echo '[Docker-apps] -- Installing pre-requisites (Docker-ce and Nvidia-docker)' 

# Docker install from official repo
if [ ! -n "$(apt search docker-ce-cli | grep installed)" ]; then
	apt-get update && apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
	&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
	&& echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable' > /etc/apt/sources.list.d/docker.list \
	&& apt update && apt install -y docker-ce docker-ce-cli containerd.io && sudo gpasswd -a $USER docker && newgrp && sudo systemctl restart docker
fi

# Nvidia-docker install for official repo (Please install NVidia drivers beforehand)
if [ ! -n "$(apt search nvidia-docker2 | grep installed)" ]; then
	curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add - \
	&& echo 'deb https://nvidia.github.io/libnvidia-container/ubuntu18.04/$(ARCH) /
		deb https://nvidia.github.io/nvidia-container-runtime/ubuntu18.04/$(ARCH) /
		deb https://nvidia.github.io/nvidia-docker/ubuntu18.04/$(ARCH) /' > /etc/apt/sources.list.d/nvidia-docker.list \
	&& apt update && apt install -y nvidia-docker2
fi

