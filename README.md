# RegioHelden - Docker Development Environment

This is the common docker service for enabling local development on multiple RegioHelde projects.

## Setup

After cloning this repository, simply run:
```
docker-compose up -d
```

To check this common setup is working, connect to http://proxy.docker-common.rh-dev.eu and you should see a dashboard.

At this point, individual projects can be cloned and started with `docker-compose up`, which will automatically make
them visible on the dashboard and accessible via local browser.

## <a name="non_http"></a> Accessing non-HTTP services

If you intend on accessing services that do not run over HTTP (e.g.: PostgreSQL databases), you must currently add a
local `docker-compose.override.yml` file to export the service port.

In the PostgreSQL case, the following should do the trick:
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

## Behind the scenes

_This section is only for the curious._

The central proxy is the only service which exports ports to `localhost`. All other projects are then automatically
detected and virtual hosts rules are created to redirect each request to the appropriate service. Redirects happen only
on the HTTP level, so services using other protocols have to be handled separately (see [Accessing non-HTTP services](#non_http) above)

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
use any other TLD, it's necessary to either add it to `/etc/hosts` and map it to localhost, or have the real DNS entry
point to localhost.