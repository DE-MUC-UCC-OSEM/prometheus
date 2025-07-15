[![Build Docker Image](https://github.com/DE-MUC-UCC-OSEM/prometheus/actions/workflows/build-docker-image.yml/badge.svg)](https://github.com/DE-MUC-UCC-OSEM/prometheus/actions/workflows/build-docker-image.yml)

## Information
Prometheus running in a minimal OpenSUSE Docker Image

Using pre-built Promtheus executable version from Promtheus github project. Everything put into a minimal Container image built from an OpenSUSE tumbleweed image

## Run the image

You can run the image via Docker
```
docker run -dit ghcr.io/de-muc-ucc-osem/prometheus:3.5.0-r0-tumbleweed
```
## Configuration

A valid prometheus.yaml file must be mounted into the container.
```
-v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml
```
