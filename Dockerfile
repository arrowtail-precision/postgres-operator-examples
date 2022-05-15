ARG REGISTRY=registry.developers.crunchydata.com/crunchydata
ARG IMAGE=crunchy-postgres
ARG POSTGRES_MAJOR_VERSION=14
ARG POSTGRES_MINOR_VERSION=2
ARG CRUNCHY_IMAGE_VERSION=1
ARG TIMESCALE_VERSION=2.6.0
ARG PROMSCALE_VERSION=0.3.0
ARG TAG=ubi8-${POSTGRES_MAJOR_VERSION}.${POSTGRES_MINOR_VERSION}-${CRUNCHY_IMAGE_VERSION}
FROM ${REGISTRY}/${IMAGE}:${TAG}

ENV PG_MAJOR=${POSTGRES_MAJOR_VERSION} \
    PG_MINOR=${POSTGRES_MINOR_VERSION} \
    TS_VERSION=${TIMESCALE_VERSION} \
    PS_VERSION=${PROMSCALE_VERSION}

USER root

RUN curl -sSL -o /etc/yum.repos.d/timescale_timescaledb.repo "https://packagecloud.io/install/repositories/timescale/timescaledb/config_file.repo?os=el&dist=8" && \
    microdnf --disablerepo=crunchypg${PG_MAJOR} --disablerepo=ubi-8-baseos --disablerepo=ubi-8-appstream update -y && \
    microdnf --disablerepo=crunchypg${PG_MAJOR} --disablerepo=ubi-8-baseos --disablerepo=ubi-8-appstream install -y timescaledb-2-postgresql-${PG_MAJOR}-${TS_VERSION} timescaledb-2-loader-postgresql-${PG_MAJOR}-${TS_VERSION} && \
    curl -sSL -O https://github.com/timescale/promscale_extension/releases/download/${PS_VERSION}/promscale_extension-${PS_VERSION}.pg${PG_MAJOR}.x86_64.rpm && \
    dnf localinstall -y promscale_extension-${PS_VERSION}.pg${POSTGRES_MAJOR_VERSION}.x86_64.rpm && \
    rm promscale_extension-${PS_VERSION}.pg${PG_MAJOR}.x86_64.rpm && \
    microdnf clean all

USER 26
