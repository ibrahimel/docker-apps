# git with updated signing in a container

FROM debian:stretch-slim
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y \
	dh-autoreconf \
	libcurl4-gnutls-dev \
	libexpat1-dev \
	gettext \
	libz-dev \
	gnupg \
	libssl-dev \
	tar \
	wget \
	asciidoc \
	xmlto \
	docbook2x \
	install-info \
	locales \
	openssh-client \
	ssh-askpass-gnome \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
	&& locale-gen en_US.UTF-8 \
	&& localedef -i en_US -f UTF-8 en_US.UTF-8 \
	&& dpkg-reconfigure locales

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

RUN apt update && apt install strace ltrace nano gdb sudo curl unzip -y

COPY did-git-impl/ /opt/did-git-impl

ENV HOME /home/git-did
RUN useradd --create-home --home-dir $HOME git-did \
	&& echo 'git-did ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
	&& chown -R git-did:git-did $HOME

WORKDIR $HOME
USER git-did

RUN sh -c "cp -r /opt/did-git-impl $HOME/"

RUN sh -c "cd $HOME/did-git-impl && \
			make configure && \
			./configure --prefix=/usr && \
			make all"

#RUN sh -c "cd $HOME/did-git-impl/t && \
#			make all && \
#			./did-tests.sh"

#RUN sh -c "cat $HOME/did-git-impl/t/test.log | grep -B 1 'not ok'"

VOLUME ["$HOME"]

ENTRYPOINT	[ "bash" ]
