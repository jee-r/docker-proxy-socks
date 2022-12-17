# docker-proxy-socks

[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/j33r/proxy-socks?style=flat-square)](https://hub.docker.com/r/j33r/proxy-socks)
[![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/jee-r/docker-proxy-socks/Deploy/main?style=flat-square)](https://github.com/jee-r/docker-proxy-socks/actions/workflows/deploy.yaml?query=branch%3Amain)
[![Docker Pulls](https://img.shields.io/docker/pulls/j33r/proxy-socks?style=flat-square)](https://hub.docker.com/r/j33r/proxy-socks)
[![DockerHub](https://img.shields.io/badge/Dockerhub-j33r/proxy%2D-socks-%232496ED?logo=docker&style=flat-square)](https://hub.docker.com/r/j33r/proxy-socks)
[![ghcr.io](https://img.shields.io/badge/ghcr%2Eio-jee%2D-r/proxy%2D-socks-%232496ED?logo=github&style=flat-square)](https://ghcr.io/jee-r/proxy-socks)

A docker image for [proxy sock5](https://en.wikipedia.org/wiki/SOCKS#SOCKS5) with [autossh](https://man.archlinux.org/man/autossh.1) and [sshpass](https://man.archlinux.org/man/sshpass.1).


## What is a Proxy Socks ?

From [Wikipedia](https://wikipedia.org/wiki/SOCKS):

> SOCKS is an Internet protocol that exchanges network packets between a client and server through a proxy server. SOCKS5 optionally provides authentication so only authorized users may access a server. Practically, a SOCKS server proxies TCP connections to an arbitrary IP address, and provides a means for UDP packets to be forwarded.

- SSH documentation : https://man.openbsd.org/ssh 
- OpenSSH Official Website : https://www.openssh.com

## How to use these images

All the lines commented in the examples below should be adapted to your environment. 

Note: `--user $(id -u):$(id -g)` should work out of the box on linux systems. If your docker host run on windows or if you want specify an other user id and group id just replace with the appropriates values.


### With Docker

```bash
docker run \
    --detach \
    --interactive \
    --name proxy \
    --user $(id -u):$(id -g) \
    #--publish 7890:7890 \
    #--env REMOTEHOST=remote_ssh_host \
    #--env REMOTEUSER=remote_ssh_user \
    #--env REMOTEPWD=remote_ssh_password \
    #--env REMOTEPORT=remote_ssh_port \
    #--env LOCALPORT=7890 \
    #--env TZ=Europe/Paris \
    --volume /etc/localtime:/etc/localtime:ro \
    #--volume ./config:/config \
    ghcr.io/jee-r/proxy-socks:latest
```

### With Docker Compose

[`docker-compose`](https://docs.docker.com/compose/) can help with defining the `docker run` config in a repeatable way rather than ensuring you always pass the same CLI arguments.

Here's an example `docker-compose.yml` config:

```yaml
version: '3'

services:
  beets:
    image: ghcr.io/jee-r/proxy-socks:latest
    container_name: proxy-socks
    restart: unless-stopped
    user: $(id -u):$(id -g)
    #ports:
      # - 7890:7890
    #environment:
      #- REMOTEHOST=remote_ssh_host
      #- REMOTEUSER=remote_ssh_user
      #- REMOTEPWD=remote_ssh_password
      #- REMOTEPORT=remote_ssh_port
      #- LOCALPORT=7890
      #- TZ=Europe/Paris
    volumes:
      #- ./config:/config
      - /etc/localtime:/etc/localtime:ro
    healthcheck:
      test: ["CMD", "curl", "-Ss", "--socks5", "127.0.0.1:7890", "--connect-timeout", "100", "--max-time", "119", "https://ifconfig.co"]
      interval: 240s
      timeout: 120s
```

### Volume mounts

Due to the ephemeral nature of Docker containers these images provide a number of optional volume mounts to persist data outside of the container:

- `/config` contain : 
  - `key`: private ssh key (600).
  - `key.pub`: public ssh key (755)
- `/etc/localtime`: This directory allow to have the same time in the container as on the host.

You should create directory before run the container otherwise directories are created by the docker deamon and owned by the root user

### Environment variables

- `REMOTEHOST`: Remote SSH host can be an IPV4 or a [FQDN](https://wikipedia.org/wiki/Fully_qualified_domain_name) . 
- `REMOTEUSER`: Remote SSH user.
- `REMOTEPWD`: Remote SSH passord.
- `REMOTEPORT`: Remote SSH port.
- `LOCALPORT`: Local forwarded port (default: `7890`).
- `TZ`: To change the timezone of the container set the `TZ` environment variable. The full list of available options can be found on [Wikipedia](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

### Ports

- `7890`: Default local forwarded port 

## Troubleshooting

- `No user exists for uid <uid>` :
  
  copy [passwd file](/rootfs/etc/passwd) edit the line below with the appropriate `UID` and `GID` 
  ```
  abc:x:<UID>:<GID>:abc:/config:/bin/ash
  ```

  and mount it as a volume

  * `docker-compose.yaml`
  ```
  ...
  volumes:
      - ./config:/config
      - /etc/localtime:/etc/localtime:ro
      - ./passwd:/etc/passwd:ro
  ...
  ```
## License

This project is under the [GNU Generic Public License v3](/LICENSE) to allow free use while ensuring it stays open.
