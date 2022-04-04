#!/bin/sh

scp "./traefik.yml" "root@kindelia.org:/root/traefik/traefik.yml"

# docker_context_current=$(docker context show)
# docker context use kindelia-org

docker-compose up -d

# docker context use "$docker_context_current"
