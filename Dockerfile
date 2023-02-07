# These values will be overriden by the values passed in from
# the Github Actions workflow file.
ARG REGISTRY=registry.developers.crunchydata.com/crunchydata
ARG IMAGE=crunchy-postgres-gis
ARG POSTGRES_MAJOR_VERSION=14
ARG POSTGRES_MINOR_VERSION=6
ARG POSTGIS_VERSION=3.3
ARG CRUNCHY_IMAGE_VERSION=2
ARG TIMESCALE_VERSION=2.6.1
ARG TIMESCALE_TOOLKIT_VERSION=1.13.1
# NOT Promscale itself; see here; https://github.com/timescale/promscale_extension/releases
ARG PROMSCALE_EXT_VERSION=0.7.0
ARG POSTGRESQL_UNIT_VERSION=7.5-3
ARG TAG=ubi8-${POSTGRES_MAJOR_VERSION}.${POSTGRES_MINOR_VERSION}-${POSTGIS_VERSION}-${CRUNCHY_IMAGE_VERSION}

# Find CrunchyData image versions here;
# https://www.crunchydata.com/developers/download-postgres/containers/postgresql14
FROM ${REGISTRY}/${IMAGE}:${TAG}

ARG POSTGRES_MAJOR_VERSION
ARG POSTGRES_MINOR_VERSION
ARG CRUNCHY_IMAGE_VERSION
ARG POSTGIS_VERSION
ARG TIMESCALE_VERSION
ARG TIMESCALE_TOOLKIT_VERSION
ARG PROMSCALE_EXT_VERSION
ARG POSTGRESQL_UNIT_VERSION

USER root

# COPY postgresql-15-unit-${POSTGRESQL_UNIT_VERSION}.x86_64.rpm /tmp/postgresql-15-unit-${POSTGRESQL_UNIT_VERSION}.x86_64.rpm

# RUN rpm -qpi /tmp/postgresql-15-unit-${POSTGRESQL_UNIT_VERSION}.x86_64.rpm | head -1

RUN curl -sSL -o /etc/yum.repos.d/timescale_timescaledb.repo "https://packagecloud.io/install/repositories/timescale/timescaledb/config_file.repo?os=el&dist=8" && \
    microdnf --disablerepo=crunchypg${POSTGRES_MAJOR_VERSION} --disablerepo=ubi-8-baseos-rpms --disablerepo=ubi-8-appstream-rpms --setopt=install_weak_deps=0 update -y && \
    microdnf --disablerepo=crunchypg${POSTGRES_MAJOR_VERSION} --disablerepo=ubi-8-baseos-rpms --disablerepo=ubi-8-appstream-rpms --setopt=install_weak_deps=0 install -y \
        timescaledb-2-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION}-0.el8.x86_64 \
        timescaledb-2-loader-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION}-0.el8.x86_64 \
        timescaledb-toolkit-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_TOOLKIT_VERSION}-0.x86_64 \
        http://deb.debian.org/debian/pool/main/p/postgresql-unit/postgresql-unit_7.7.orig.tar.gz && \
        # promscale-extension-postgresql-${POSTGRES_MAJOR_VERSION}-${PROMSCALE_EXT_VERSION}-1.x86_64 && \
    # curl -sSL -O https://github.com/timescale/promscale_extension/releases/download/${PROMSCALE_EXT_VERSION}/promscale-extension-${PROMSCALE_EXT_VERSION}.pg${POSTGRES_MAJOR_VERSION}.centos7.x86_64.rpm && \
    # rpm -ivh promscale-extension-${PROMSCALE_EXT_VERSION}.pg${POSTGRES_MAJOR_VERSION}.centos7.x86_64.rpm && \
    # rm promscale-extension-${PROMSCALE_EXT_VERSION}.pg${POSTGRES_MAJOR_VERSION}.centos7.x86_64.rpm && \
    # rpm -ivh --prefix=/usr/pgsql-14/share/extension /tmp/postgresql-15-unit-${POSTGRESQL_UNIT_VERSION}.x86_64.rpm && \
    microdnf clean all

USER 26
