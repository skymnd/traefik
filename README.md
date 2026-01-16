# Traefik in a homelab

This repo is my personal configuration for using traefik
on my homelab.
Traefik is a reverse-proxy and the
[traefik docs](https://doc.traefik.io/traefik/) are 
pretty good and can explain a bit more about what that
means.
This traefik instance is currently not internet-facing
and is deployed using the service in the `docker-compose.yml`
file.

## Let's Encrypt

This configuration will use traefik's acme to get
HTTPS on the local network. Once acme has been setup,
before being able to access services with the new domain,
you still need to update your DNS to point the domain
name to the traefik instance.

## File Provider

A cool feature of traefik is that by using tags it can
automatically discover containers using the "docker
provider".
However, although I have set up a lot of services
through docker, I have set them up on individual VMs
so they can't share the same docker network.
Because of this, I am making heavy use of the "file
provider" instead; the config for which can be found in the
`dynamic/` directory, with one file corresponding to
one service.

## Environment variables

I have included template files for the environment
variables, which should be fairly self-explanatory,
but if hosting all these services on a common
docker network, you shouldn't need the IP env vars.