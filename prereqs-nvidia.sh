#!/bin/bash

# Install pre-requisites for Ubuntu 18.04 + 19.04
# (Nvidia only supports bionic thus the forced bionic below)
# When Nvidia adds suport for cosmic and disco we can use $ubuntu_release or whatever ...
# But they will most likely only support latest LTS release ...

echo '[Docker-apps] -- Installing pre-requisites (Docker-ce and Nvidia-docker)' 

# Docker install from official repo
if [ ! -n "$(apt search docker-ce-cli | grep installed)" ]; then
	echo 'Docker not found, Installing it'
	sudo apt-get update && sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
	&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
	&& echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable' > /etc/apt/sources.list.d/docker.list \
	&& sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io && sudo gpasswd -a $USER docker && newgrp - docker && sudo systemctl restart docker
else
	echo 'Docker already installed !'
fi

# Nvidia-docker install for official repo (Please install NVidia drivers beforehand)
if [ ! -n "$(apt search nvidia-docker2 | grep installed)" ]; then
	if [ -f "/proc/driver/nvidia/version" ]; then
		curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
		&& sudo echo 'deb https://nvidia.github.io/libnvidia-container/ubuntu18.04/$(ARCH) /
			deb https://nvidia.github.io/nvidia-container-runtime/ubuntu18.04/$(ARCH) /
			deb https://nvidia.github.io/nvidia-docker/ubuntu18.04/$(ARCH) /' > /etc/apt/sources.list.d/nvidia-docker.list \
		&& sudo apt update && sudo apt install -y nvidia-docker2
	else
		echo 'Not an Nvidia system !'
	fi
else
	echo 'Nvidia docker runtime already installed !'
fi

echo '[Docker-apps] -- Done' 
