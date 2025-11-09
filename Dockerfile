# These values will be overriden by the values passed in from
# the Github Actions workflow file.
ARG REGISTRY=registry.developers.crunchydata.com/crunchydata
ARG IMAGE=crunchy-postgres-gis
ARG POSTGRES_MAJOR_VERSION=18
ARG POSTGRES_MINOR_VERSION=0
ARG POSTGIS_VERSION=3.6
ARG CRUNCHY_IMAGE_VERSION=0
ARG TIMESCALE_VERSION=2.23.0
ARG TIMESCALE_TOOLKIT_VERSION=1.22.0
ARG POSTGRESQL_UNIT_VERSION=7.10-4PGDG
ARG TAG=ubi9-${POSTGRES_MAJOR_VERSION}.${POSTGRES_MINOR_VERSION}-${POSTGIS_VERSION}-${CRUNCHY_IMAGE_VERSION}

# Find CrunchyData image versions here;#
# https://www.crunchydata.com/developers/download-postgres/containers/postgresql15
FROM ${REGISTRY}/${IMAGE}:${TAG}

ARG POSTGRES_MAJOR_VERSION
ARG POSTGRES_MINOR_VERSION
ARG CRUNCHY_IMAGE_VERSION
ARG POSTGIS_VERSION
ARG TIMESCALE_VERSION
ARG TIMESCALE_TOOLKIT_VERSION
ARG POSTGRESQL_UNIT_VERSION

USER root

RUN curl -sSL -o /etc/yum.repos.d/timescale_timescaledb.repo "https://packagecloud.io/install/repositories/timescale/timescaledb/config_file.repo?os=el&dist=9" && \
    curl -sSL -o /tmp/pgdg-redhat-repo-latest.noarch.rpm "https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm" && \
    rpm -ivh /tmp/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf --disablerepo=pgdg-common --disablerepo=pgdg15 --disablerepo=ubi-9-baseos-rpms --disablerepo=ubi-9-appstream-rpms --setopt=install_weak_deps=0 update -y && \
    microdnf --disablerepo=ubi-9-baseos-rpms --disablerepo=ubi-9-appstream-rpms --setopt=install_weak_deps=0 install -y \
        postgresql-unit_${POSTGRES_MAJOR_VERSION}-${POSTGRESQL_UNIT_VERSION}.rhel9.x86_64 \
        timescaledb-2-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION}-0.el9.x86_64 \
        timescaledb-2-loader-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION}-0.el9.x86_64 \
        timescaledb-toolkit-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_TOOLKIT_VERSION}-0.x86_64 && \
    rm /tmp/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf clean all

USER 26
