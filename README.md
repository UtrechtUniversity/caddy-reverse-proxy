# Caddy Reverse Proxy with HTTP Basic Auth

This repository provides a container image for a reverse proxy based on [Caddy](https://github.com/caddyserver/caddy/), with HTTP basic authentication enabled.

You can configure the proxy's behavior and authentication using environment variables passed to the container.
This provides a very simple way to dynamically configure HTTP basic auth in a Kubernetes application, using environment variables and secrets, without having to use e.g. [Traefik](https://doc.traefik.io/), which requires access to the Kubernetes API to dynamically set routing options.

## Settings

The container supports the following environment variables (with defaults):

```bash
LISTEN_HOST="" # hostname on which Caddy should listen (default = empty, = localhost)
LISTEN_PORT=80 # port on which Caddy should listen
SERVICE_HOST="" # hostname to which Caddy should reverse proxy (default = empty, = localhost)
SERVICE_PORT=5000 # port of the service Caddy should reverse proxy to
BASIC_USER=caddy # username for HTTP basic auth
BASIC_PW="" # hashed password for HTTP basic auth
MATCHER="" # Caddy matcher for the path that should be protected with basic auth (default is empty to match everything, but can also be e.g. '/secret/*')
HASH_ALGO=bcrypt # what kind of hash the provided password uses
REALM="" # name of the HTTP basic auth realm
```

## Repo outline

This repo contains:

* A `Dockerfile` to build the image
* A `Caddyfile` that interpolates the above environment variables 
* [OpenShift configuration](#using-with-openshift) to create an [ImageStream](image-streams.yaml) and [BuildConfig](build-config.yaml) based on the Dockerfile

### Using with OpenShift

Using OpenShift image streams and build configs we can follow the upstream `caddy:2` Docker image, and rebuild the reverse proxy container image whenever a new version of Caddy is released. This allows us to keep the reverse proxy image up to date and secure.

This repo provides ImageStream definitions for:

* `approved-caddy`, an ImageStream that tracks the `caddy:2` image by default
* `caddy-reverse-proxy`, an ImageStream that contains a version of the reverse proxy container built with `approved-caddy` as a base
* a BuildConfig that build a new version of `caddy-reverse-proxy`, based on the Dockerfile in this repo, whenever `approved-caddy` is updated

To apply:

```bash
oc apply -f image-streams.yaml
oc apply -f build-config.yaml
```

When the build finishes, you should see `caddy-reverse-proxy` when listing all ImageStreams with `oc get is`. You can get the name of the local image that you can reference in your pods with `oc describe is caddy-reverse-proxy`.

## Limitations

The configuration options are interpolated into a very simply [Caddyfile](Caddyfile), so currently:

* There is no support for setting multiple basic auth username/password combinations
* Fine-tuning proxy settings is not supported (Caddy basic settings are used)

This is good enough for simple protection of e.g. an API service that doesn't require multiple users to be able to authenticate.
