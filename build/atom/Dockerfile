# Atom in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	gnupg \
	wget \
	--no-install-recommends

RUN wget -qO- https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'

RUN apt-get update && apt-get install -y \
	atom \
	git \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/atom
RUN useradd --create-home --home-dir $HOME atom \
	&& gpasswd -a atom audio \
	&& chown -R atom:atom $HOME

WORKDIR $HOME
USER atom

# Autorun atom
ENTRYPOINT [ "atom", "--foreground" ]
