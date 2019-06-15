# Kali linux full container

FROM nvidia/opencl
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y \
	apt-transport-https \
	ca-certificates \
	gnupg \
	wget \
	--no-install-recommends

RUN wget -O /tmp/kali.deb "https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2018.1_all.deb" && dpkg -i /tmp/kali.deb

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && echo '' > /etc/apt/source.list

RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" \
	> /etc/apt/sources.list.d/kali.list \
	&& echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" \
	>> /etc/apt/sources.list.d/kali.list

RUN apt update \
	&& apt install -y kali-linux-full \
	--install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/kali
RUN useradd --create-home --home-dir $HOME kali \
	&& gpasswd -a kali sudo \
	&& echo 'kali ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
	&& chown -R kali:kali $HOME

RUN chown root:kali /usr/bin/dumpcap \
	&& setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap

WORKDIR $HOME
USER kali

# Autorun bash
ENTRYPOINT [ "bash" ]
