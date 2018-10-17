# RegioHelden - Docker Development Environment

This is the common docker setup for enabling local development on multiple RegioHelden projects and multiple operating systems (Linux and OSX; Windows untested).

## Dependencies

The only dependency for this project is [docker](https://docker.io).
On Linux: `snap install docker`
On OSX: go to [here](https://docs.docker.com/docker-for-mac/install/) and follow the instructions.

## Setup

After cloning this repository, simply run:
```
$ ./bootstrap.sh
```

At this point, individual projects can be cloned and started with `docker-compose up`, which will automatically make
them accessible via local browser with their respective domains under `.rh-dev.eu`.

To make usage of docker less burdensome, the `aliases.sh` file contains common aliases. It can be sourced by adding
`source PATH_TO_REPO/aliases.sh` to your shell config (i.e.: `~/.bashrc`, `~/.zshrc`, etc)

## Known issues and workarounds

### <a name="osx_non_http"></a> OSX: Accessing non-HTTP services

If you intend on accessing services that do not run over HTTP (e.g.: PostgreSQL databases), you must currently add a
local `docker-compose.override.yml` file to export the service port.

In the PostgreSQL case:
```yaml
version: '3.5'
services:
  db:
    ports:
      - "15432:5432"
```

This would make the PostgreSQL `db` service accessible on `localhost:15432`

Note the `1` in front of the exported port. This could be changed for each separate project, so that multiple
PostgreSQL containers would remain simultaneously accessible.

## Adding new projects

To make use of this common infrastructure and make development on multiple platforms as similar as currently possible,
the individual projects must have some common settings. The project's `docker-compose.yaml` file should include:

```yaml
services:
  SOMESERVICE:
    ...
    networks:
      regiohelden:
        aliases:
          - SOMEALIAS
    labels:
      - "traefik.frontend.rule=Host:SOMEALIAS.rh-dev.eu"
      - "traefik.port=8000"  # only needed if service exposes multiple ports
    ...
```

In this case, `SOMESERVICE` will usually be the stack name, like `django` or `angular` (this makes aliases across
projects easier; see `aliases.sh`) and `SOMEALIAS` will be the service's subdomain under `rh-dev.eu`.


## Behind the scenes

_This section is only for the curious._

### Linux

Individual services' networks can be access directly under linux. This makes it possible to have multiple services
listening on the same port (e.g. django on `8000`), each on its own IP.

To access these IPs, which are dynamically allocated by docker, we need some way to map domain names to them. For this
we make use of an extra container that listens for docker events and updates the local `/etc/hosts` files accordingly,
adding or removing entries for specific entries.

The `/etc/hosts` entries are created for each of the following the formats:
- `SERVICE_NAME`
- `SERVICE_NAME.NETWORK_NAME`
- `SERVICE_NAME.PROJECT_NAME.NETWORK_NAME`
- `SERVICE_ALIAS`
- `SERVICE_ALIAS.NETWORK_NAME`
- `SERVICE_ALIAS.PROJECT_NAME.NETWORK_NAME`

So a service defined as follows, inside the `someproject` folder:
```yaml
services:
  ...
  someservice:
    networks:
      somenetwork:
        aliases:
          - somealias
  ...
```
Would be accessible under the following names: `someservice`, `someservice.somenetwrok`, `someservice.someproject.somenetwork`, `somealias`, `somealias.somenetwork` and `somealias.someproject.somenetwork`.

### OSX

In the case of OSX, the individual services are accessed through a central proxy.

This central proxy is the only service which exports ports to `localhost`. All other projects are then automatically
detected and virtual hosts rules are created to redirect each request to the appropriate service. Redirects happen only
on the HTTP level, so services using other protocols have to be handled separately (see [Accessing non-HTTP services](#osx_non_http) above)

Virtual hosts are created for each started service following the format `SERVICE_NAME.PROJECT_NAME.rh-dev.eu`.
Additional names can be added via the `traefik.frontend.rule` service label. E.g.:
```yaml
...
services:
  someservice:
    labels:
      - "traefik.frontend.rule=Host:some.url.com"
...
```

All domains under `rh-dev.eu` resolve to localhost, so this works for these subdomains automatically. If you want to
use any other TLD, it's necessary to either add it to `/etc/hosts` and map it to localhost, or have its real DNS entry
point to localhost.
