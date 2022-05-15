ARG REGISTRY=registry.developers.crunchydata.com/crunchydata
ARG IMAGE=crunchy-postgres
ARG POSTGRES_MAJOR_VERSION=14
ARG POSTGRES_MINOR_VERSION=2
ARG CRUNCHY_IMAGE_VERSION=1
ARG TIMESCALE_VERSION=2.6.0
ARG PROMSCALE_VERSION=0.3.0
ARG TAG=ubi8-${POSTGRES_MAJOR_VERSION}.${POSTGRES_MINOR_VERSION}-${CRUNCHY_IMAGE_VERSION}
FROM ${REGISTRY}/${IMAGE}:${TAG}

USER root

RUN curl -sSL -o /etc/yum.repos.d/timescale_timescaledb.repo "https://packagecloud.io/install/repositories/timescale/timescaledb/config_file.repo?os=el&dist=8" && \
    microdnf update -y && \
    microdnf install -y timescaledb-2-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION} timescaledb-2-loader-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION} && \
    curl -sSL -O https://github.com/timescale/promscale_extension/releases/download/${PROMSCALE_VERSION}/promscale_extension-${PROMSCALE_VERSION}.pg${POSTGRES_MAJOR_VERSION}.x86_64.rpm && \
    microdnf localinstall -y promscale_extension-${PROMSCALE_VERSION}.pg${POSTGRES_MAJOR_VERSION}.x86_64.rpm && \
    rm promscale_extension-${PROMSCALE_VERSION}.pg${POSTGRES_MAJOR_VERSION}.x86_64.rpm && \
    microdnf clean all

USER 26
