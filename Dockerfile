FROM alpine:3.14

LABEL ddmaintainer="Jee <jee[at]jeer.fr>"

LABEL name="git-mirror" \
    	maintainer="Jee jee@jeer.fr" \
      description="proxy socks5 with autoreonnect and healthcheck" \
	    url="https://github.com/jee-r/docker-proxy" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-proxy" \
      org.opencontainers.image.source="https://github.com/jee-r/docker-proxy"

COPY rootfs /

ENV REMOTEHOST="CHANGE_ME" \
	REMOTEUSER="CHANGE_ME" \
	REMOTEPORT="CHANGE_ME" \
	LOCALPORT="7890" 

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

ENTRYPOINT ["/us/local/bin/entrypoint.sh"]