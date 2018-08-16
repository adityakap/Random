FROM alpine:3.6

LABEL maintainer="Deluxe"
ARG JMETER_VERSION="4.0"


ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN  ${JMETER_HOME}/bin
ENV MIRROR_HOST http://mirrors.ocf.berkeley.edu/apache/jmeter
ENV YOUR_TOKEN {token}
ENV JMETER_PLUGINS_DOWNLOAD_URL http://repo1.maven.org/maven2/kg/apc

RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	#&& update-ca-certificates \
            && apk add --update openjdk8-jre tzdata curl unzip bash tar \
            && cp /usr/share/zoneinfo/Europe/Rome /etc/localtime \
            && echo "Europe/Rome" >  /etc/timezone \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies
RUN curl -s  -H "Authorization: token ${YOUR_TOKEN}" -L 'https://api.github.com/repos/d3sw/QA-OWF-Automation/contents/Tools/jmeter/' | grep tgz | grep ${JMETER_VERSION} | grep download_url | cut -d' ' -f6 | rev | cut -c 2- | rev | xargs -n1 curl -H "Authorization: token ${YOUR_TOKEN}" -o /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -L
RUN mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

ENV PATH $PATH:$JMETER_BIN

COPY launch.sh /

WORKDIR ${JMETER_HOME}

RUN chmod +x /launch.sh \
&& chmod -R 777 /opt
ENTRYPOINT ["/launch.sh"]
