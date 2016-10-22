FROM armhf/alpine:latest
MAINTAINER armswarm

# metadata params
ARG PROJECT_NAME
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF

# metadata
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$PROJECT_NAME \
      org.label-schema.url=$VCS_URL \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor="armswarm" \
      org.label-schema.version="latest"

ARG ALERTMANAGER_VERSION
ENV ALERTMANAGER_VERSION=${ALERTMANAGER_VERSION}

RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl && \

# install syncthing
 curl -so \
 /tmp/alertmanager.tar.gz -L \
    "https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7.tar.gz" && \
 tar xfz \
    /tmp/alertmanager.tar.gz -C /tmp && \

 mkdir -p \
    /etc/alertmanager && \

 mv /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/alertmanager /bin/alertmanager && \
 mv /tmp/alertmanager-${ALERTMANAGER_VERSION}.linux-armv7/simple.yml /etc/alertmanager/config.yml && \

# clean up
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

EXPOSE 9093

VOLUME ["/alertmanager"]

WORKDIR /alertmanager

ENTRYPOINT ["/bin/alertmanager"]

CMD ["-config.file=/etc/alertmanager/config.yml", \
     "-storage.path=/alertmanager" ]
