FROM quay.io/evryfs/base-python:3.13.3
ARG BUILD_DATE
ARG BUILD_URL
ARG GIT_URL
ARG GIT_COMMIT
ARG PY_VER
ARG UVICORN_VERSION
ARG GUNICORN_VERSION
ARG VERSION
LABEL maintainer="Kristian Berg <kristian.berg@evry.com>" \
  org.opencontainers.image.title="base-python-asgi" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.authors="Kristian Berg <kristian.berg@tietoevry.com>" \
  org.opencontainers.image.url=$BUILD_URL \
  org.opencontainers.image.documentation="https://github.com/evryfs/base-python-asgi/" \
  org.opencontainers.image.source=$GIT_URL \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$GIT_COMMIT \
  org.opencontainers.image.vendor="Tietoevry Banking" \
  org.opencontainers.image.licenses="proprietary-license" \
  org.opencontainers.image.description="Base image for ASGI apps using python $PY_VER with uvicorn $UVICORN_VERSION and gunicorn $GUNICORN_VERSION"

ENV UVICORN_PORT 8000
ENV UVICORN_HOST 0.0.0.0
ENV CONTEXT_ROOT ""
USER root
RUN apt-get update && \
  apt-get install -y gcc && \
  apt-get -y clean && \
  rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
RUN apt-get purge -y gcc && rm -rf /var/lib/apt/lists/*
COPY start_uvicorn /bin/
RUN chmod 755 /bin/start_uvicorn
USER 1001:100
WORKDIR /app
EXPOSE $UVICORN_PORT
ENTRYPOINT ["/bin/start_uvicorn"]
