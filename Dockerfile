FROM ubuntu:xenial
MAINTAINER Lars Kellogg-Stedman <lars@oddbit.com>
MAINTAINER mf-lit <mf-lit@vq5.net>

ENV LMS_VERSION="7.9.2"

ENV SQUEEZE_VOL /srv/squeezebox
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGE_VERSION_URL=http://www.mysqueezebox.com/update/?version=7.9.0&revision=1&geturl=1&os=deb

RUN apt-get update && \
	apt-get -y install \
		curl \
		wget \
		faad \
		flac \
		lame \
		sox \
		libio-socket-ssl-perl \
		tzdata \
		&& \
	apt-get clean

RUN url="http://downloads.slimdevices.com/LogitechMediaServer_v${LMS_VERSION}/logitechmediaserver_${LMS_VERSION}_amd64.deb" && \
	curl -Lsf -o /tmp/logitechmediaserver.deb $url && \
	dpkg -i /tmp/logitechmediaserver.deb && \
	rm -f /tmp/logitechmediaserver.deb && \
	apt-get clean

# This will be created by the entrypoint script.
RUN userdel squeezeboxserver

VOLUME $SQUEEZE_VOL
EXPOSE 3483 3483/udp 9000 9090 5353/udp

COPY entrypoint.sh /entrypoint.sh
COPY start-squeezebox.sh /start-squeezebox.sh
RUN chmod 755 /entrypoint.sh /start-squeezebox.sh
ENTRYPOINT ["/entrypoint.sh"]
