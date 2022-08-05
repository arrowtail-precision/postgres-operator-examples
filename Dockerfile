ARG REGISTRY=registry.developers.crunchydata.com/crunchydata
ARG IMAGE=crunchy-postgres
ARG POSTGRES_MAJOR_VERSION=14
ARG POSTGRES_MINOR_VERSION=4
ARG CRUNCHY_IMAGE_VERSION=0
ARG TIMESCALE_VERSION=2.6.1
ARG PROMSCALE_VERSION=0.13.0
ARG TAG=ubi8-${POSTGRES_MAJOR_VERSION}.${POSTGRES_MINOR_VERSION}-${CRUNCHY_IMAGE_VERSION}

# Find CrunchyData image versions here;
# https://www.crunchydata.com/developers/download-postgres/containers/postgresql14
FROM ${REGISTRY}/${IMAGE}:${TAG}

ARG POSTGRES_MAJOR_VERSION
ARG POSTGRES_MINOR_VERSION
ARG CRUNCHY_IMAGE_VERSION
ARG TIMESCALE_VERSION
ARG PROMSCALE_VERSION

USER root

RUN curl -sSL -o /etc/yum.repos.d/timescale_timescaledb.repo "https://packagecloud.io/install/repositories/timescale/timescaledb/config_file.repo?os=el&dist=8" && \
    microdnf --disablerepo=crunchypg${POSTGRES_MAJOR_VERSION} --disablerepo=ubi-8-baseos --disablerepo=ubi-8-appstream --setopt=install_weak_deps=0 update -y && \
    microdnf --disablerepo=crunchypg${POSTGRES_MAJOR_VERSION} --disablerepo=ubi-8-baseos --disablerepo=ubi-8-appstream --setopt=install_weak_deps=0 install -y timescaledb-2-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION} timescaledb-2-loader-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION} timescaledb-toolkit-postgresql-${POSTGRES_MAJOR_VERSION} && \
    curl -sSL -O https://github.com/timescale/promscale_extension/releases/download/${PROMSCALE_VERSION}/promscale_extension-${PROMSCALE_VERSION}.pg${POSTGRES_MAJOR_VERSION}.x86_64.rpm && \
    rpm -qpl promscale_extension-${PROMSCALE_VERSION}.pg${POSTGRES_MAJOR_VERSION}.x86_64.rpm && \
    rm promscale_extension-${PROMSCALE_VERSION}.pg${POSTGRES_MAJOR_VERSION}.x86_64.rpm && \
    microdnf clean all

USER 26
