FROM alpine:3.14

LABEL name="docker-proxy-socks" \
    	maintainer="Jee jee@jeer.fr" \
      description="proxy socks5 with autoreconnect and healthcheck" \
	    url="https://github.com/jee-r/docker-proxy-socks" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-proxy-socks" \
      org.opencontainers.image.source="https://github.com/jee-r/docker-proxy-socks"

COPY rootfs /

ENV REMOTEHOST="CHANGE_ME" \
	  REMOTEUSER="CHANGE_ME" \
	  REMOTEPORT="CHANGE_ME" \
	  LOCALPORT="7890" \
    UID="1000" \
    GID="1000" \
    TZ="Europe/Paris"

RUN apk update && \
	apk upgrade --no-cache && \
	apk add --upgrade --no-cache \
		autossh \ 
		curl \
    sshpass && \
	chmod +x \
		/usr/local/bin/entrypoint.sh \
		/usr/local/bin/healthcheck.sh && \
	rm -rf /tmp/* /var/cache/apk/* 

EXPOSE 7890
VOLUME /config

HEALTHCHECK --interval=5m --timeout=60s --start-period=30s \
    CMD /usr/local/bin/healthcheck.sh || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]