# Python ASGI base image

[![Docker Repository on Quay](https://quay.io/repository/evryfs/base-python-asgi/status "Docker Repository on Quay")](https://quay.io/repository/evryfs/base-python-asgi)

This image forms the basis for running python ASGI applications. It is based on
the Tietoevry python base image and uses uvicorn.

## Usage

The image bundles a wrapper script for uvicorn at `/bin/start_uvicorn`. It uses
environment flags to control how the ASGI application is started.

### Available flags

| Flag              | Default | Comment                                   |
| ----------------- | ------- | ----------------------------------------- |
| UVICORN_PORT      | 8000    | Application port.                         |
| UVICORN_HOST      | 0.0.0.0 | Application bind address.                 |
| UVICORN_LOG_LEVEL | info    | Set uvicorn log level.                    |
| CONTEXT_ROOT      | None    | Context root where application is served. |

### Creating a Dockerfile

To utilize this image to create a container for your application, create a new
Dockerfile based on this. Then add your python sauce to the container and set
the name of the ASGI module with `CMD ["module:callable"]`.

```dockerfile
FROM quay.io/evryfs/base-python-asgi:3.13-stable
ARG BUILD_DATE
ARG BUILD_URL
ARG GIT_URL
ARG GIT_COMMIT
LABEL maintainer="Your Name <your.email.here@evry.com>"
      com.finods.ccm.system="<system short name>"
      com.finods.ccm.group="<finods group>"
      org.opencontainers.image.title="<application name>"
      org.opencontainers.image.created=$BUILD_DATE
      org.opencontainers.image.authors="<name of system responsible>"
      org.opencontainers.image.url=$BUILD_URL
      org.opencontainers.image.documentation="<link to SAD>"
      org.opencontainers.image.source=$GIT_URL
      org.opencontainers.image.version="<version number>"
      org.opencontainers.image.revision=$GIT_COMMIT
      org.opencontainers.image.vendor="Tietoevry Banking"
      org.opencontainers.image.licenses="proprietary-license"
      org.opencontainers.image.description="<system description>"

COPY . .
CMD ["asgi_module:app"]
```

The default workdir for this image is /app, so any sauce will be copied there.
Remember to reset WORKDIR to /app, if you do additional steps in your derivative
image. The wrapper scripts depends on the module being either in python's
site-packages or present in the current directory.
