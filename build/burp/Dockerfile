# Burpsuite in a container

FROM ubuntu
LABEL maintainer "Ibrahim El Rhezzali <ibrahim.el@pm.me>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	wget \
	ca-certificates \
	openjdk-8-jre \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# burp (free)
RUN wget -O /burp.jar "https://portswigger.net/burp/releases/download?productid=100&version=1.7.36&type=jar"

RUN sed -i -e '/^assistive_technologies=/s/^/#/' /etc/java-*-openjdk/accessibility.properties

ENV HOME /home/burp
RUN useradd --create-home --home-dir $HOME burp \
	&& chown -R burp:burp $HOME \
	&& chown burp:burp /burp.jar

WORKDIR $HOME
USER burp

# Autorun Burp
ENTRYPOINT ["java", "-jar", "-Xmx1024m", "/burp.jar"]
