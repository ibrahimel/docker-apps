# Tensorflow in a container

FROM tensorflow/tensorflow:latest-gpu-py3-jupyter
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN python3 -m pip install keras

RUN apt update && apt install -y \
	npm \
	nodejs\
	git \
	gconf2 \
	gconf-service \
	gvfs-bin \
	libasound2 \
	libcap2 \
	libgconf-2-4 \
	libgtk2.0-0 \
	libgtk-3-0 \
	libnotify4 \
	libnss3 \
	libxkbfile1 \
	libxss1 \
	libxtst6 \
	libx11-xcb-dev \
	xdg-utils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN ln -s "$(which nodejs)" /usr/bin/node

RUN npm install -g nativefier

ENV HOME /home/tensorflow
RUN useradd --create-home --home-dir $HOME tensorflow \
	&& chown -R tensorflow:tensorflow $HOME

COPY install.sh /tmp

COPY tensorflow.png /usr/share/icons/

RUN /tmp/install.sh

RUN chown -R tensorflow:tensorflow /opt/jupyter-notebook-linux-x64

RUN apt update && apt install -y \
	gxmessage \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*


ENV LANG en_US.UTF-8

WORKDIR $HOME

USER tensorflow

COPY entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]