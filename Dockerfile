# These values will be overriden by the values passed in from
# the Github Actions workflow file.
ARG REGISTRY=registry.developers.crunchydata.com/crunchydata
ARG IMAGE=crunchy-postgres-gis
ARG POSTGRES_MAJOR_VERSION=14
ARG POSTGRES_MINOR_VERSION=6
ARG POSTGIS_VERSION=3.3
ARG CRUNCHY_IMAGE_VERSION=2
ARG TIMESCALE_VERSION=2.9.3
ARG TIMESCALE_TOOLKIT_VERSION=1.13.1
# NOT Promscale itself; see here; https://github.com/timescale/promscale_extension/releases
ARG PROMSCALE_EXT_VERSION=0.8.0
ARG POSTGRESQL_UNIT_VERSION=7.4-1
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

RUN curl -sSL -o /etc/yum.repos.d/timescale_timescaledb.repo "https://packagecloud.io/install/repositories/timescale/timescaledb/config_file.repo?os=el&dist=8" && \
    curl -sSL -o /tmp/pgdg-redhat-repo-latest.noarch.rpm "https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm" && \
    rpm -ivh /tmp/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf --disablerepo=crunchypg${POSTGRES_MAJOR_VERSION} --disablerepo=pgdg-common --disablerepo=pgdg14 --disablerepo=ubi-8-baseos-rpms --disablerepo=ubi-8-appstream-rpms --setopt=install_weak_deps=0 update -y && \
    microdnf --disablerepo=crunchypg${POSTGRES_MAJOR_VERSION} --disablerepo=ubi-8-baseos-rpms --disablerepo=ubi-8-appstream-rpms --setopt=install_weak_deps=0 install -y \
        postgresql-unit_${POSTGRES_MAJOR_VERSION}-${POSTGRESQL_UNIT_VERSION}.rhel8.x86_64 \
        timescaledb-2-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION}-0.el8.x86_64 \
        timescaledb-2-loader-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION}-0.el8.x86_64 \
        timescaledb-toolkit-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_TOOLKIT_VERSION}-0.x86_64 \
        promscale-extension-postgresql-${POSTGRES_MAJOR_VERSION}-${PROMSCALE_EXT_VERSION}-1.x86_64 && \
    rm /tmp/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf clean all

USER 26
