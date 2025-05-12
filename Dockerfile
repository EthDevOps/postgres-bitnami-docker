ARG POSTGRES_VERSION=17.4.0
ARG DEBIAN_VERSION=12
ARG REVISION=r19

FROM docker.io/bitnami/postgresql:${POSTGRES_VERSION}-debian-${DEBIAN_VERSION}-${REVISION}

USER root

# Install build dependencies and clone pgvector
RUN install_packages git build-essential postgresql-server-dev-17 \
    && git clone --branch v0.6.0 https://github.com/pgvector/pgvector.git \
    && cd pgvector \
    && make \
    && make install \
    && cd .. \
    && rm -rf pgvector \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-17 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER 1001

# Enable pgvector extension by default
RUN echo "CREATE EXTENSION IF NOT EXISTS vector;" > /opt/bitnami/postgresql/share/postgresql-extension.sql
