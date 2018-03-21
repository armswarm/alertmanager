FROM quay.io/armswarm/alpine:3.7

ARG ALERTMANAGER_VERSION
ENV ALERTMANAGER_VERSION=${ALERTMANAGER_VERSION}

RUN \
 apk add --no-cache ca-certificates && \
 apk add --no-cache --virtual=.fetch-dependencies \
	curl && \
# install alertmanager
 curl -so \
 /tmp/alertmanager.tar.gz -L \
    "https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz" && \
 tar xfz \
    /tmp/alertmanager.tar.gz -C /tmp && \
  mkdir -p \
    /alertmanager \
    /etc/alertmanager && \
 cd /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/ && \
 mv alertmanager amtool /bin/ && \
 mv simple.yml /etc/alertmanager/config.yml && \
 chown -R nobody:nogroup /etc/alertmanager /alertmanager && \
# clean up
 apk del --purge \
	.fetch-dependencies && \
 rm -rf \
	/tmp/*

USER nobody
EXPOSE 9093

VOLUME ["/alertmanager"]

WORKDIR /alertmanager

ENTRYPOINT ["/bin/alertmanager"]

CMD [ "--config.file=/etc/alertmanager/config.yml", \
      "--storage.path=/alertmanager" ]
