# Tor-browser in a container

FROM debian:sid-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update && apt-get install -y \
	ca-certificates \
	curl \
	dirmngr \
	gnupg \
	libasound2 \
	libpulse0 \
	apulse \
	libdbus-glib-1-2 \
	libgtk-3-0 \
	libxrender1 \
	libx11-xcb-dev \
	libx11-xcb1 \
	libxt6 \
	xz-utils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/tor-browser
RUN useradd --create-home --home-dir $HOME tor-browser \
	&& chown -R tor-browser:tor-browser $HOME

ENV LANG C.UTF-8

# https://www.torproject.org/projects/torbrowser.html.en
ENV TOR_VERSION 9.0a1

# download tor and check signature
RUN cd /tmp \
	&& curl -sSOL "https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz" \
	&& tar -vxJ --strip-components 1 -C /usr/local/bin -f tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz \
	&& rm -rf tor-browser* \
	&& chown -R tor-browser:tor-browser /usr/local/bin

# good fonts
COPY local.conf /etc/fonts/local.conf

WORKDIR $HOME
USER tor-browser

ENTRYPOINT ["/bin/bash"]
CMD [ "/usr/local/bin/Browser/start-tor-browser", "--log", "/dev/stdout" ]
