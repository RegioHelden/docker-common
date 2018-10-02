# RegioHelden - Docker Development Environment

This is the common docker service for enabling local development on multiple RegioHelde projects.

## Setup

After cloning this repository, simply run:
```
docker-compose up -d
```

To check this common setup is working, connect to http://proxy.docker-common.rh-dev.eu and you should see a dashboard.

Individual projects can than be cloned and started with `docker-compose up`, which will automatically make them visible
on the dashboard and accessible via local browser.
