FROM alpine:3.9

ENV REMOTEHOST="CHANGE_ME" \
	REMOTEUSER="CHANGE_ME" \
	REMOTEPORT="CHANGE_ME" \
	LOCALPORT="7890" \
	PUID="1000" \
	GUID="1000" 

RUN apk add --upgrade \
				  autossh \ 
				  curl \
				  su-exec \
				  tini \
	&& rm -rf /tmp/* /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chmod +x /usr/local/bin/*

HEALTHCHECK --interval=60s --timeout=20s CMD ["su-exec", "abc:abc", "healthcheck.sh"]

EXPOSE 7890

VOLUME /config

LABEL maintainer="FLiP <bs-flip@protonmail.com>"

CMD ["run.sh"]
