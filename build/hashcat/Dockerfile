# Nvidia base container

FROM nvidia/opencl
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

RUN apt-get update \
    && apt-get install -y hashcat

ENV HOME /home/hashcat
RUN useradd --create-home --home-dir $HOME hashcat \
	&& chown -R hashcat:hashcat $HOME

WORKDIR $HOME
USER hashcat

CMD /bin/bash
