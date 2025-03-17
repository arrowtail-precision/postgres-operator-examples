# These values will be overriden by the values passed in from
# the Github Actions workflow file.
ARG REGISTRY=registry.developers.crunchydata.com/crunchydata
ARG IMAGE=crunchy-postgres-gis
ARG POSTGRES_MAJOR_VERSION=16
ARG POSTGRES_MINOR_VERSION=4
ARG POSTGIS_VERSION=3.3
ARG CRUNCHY_IMAGE_VERSION=0
ARG TIMESCALE_VERSION=2.16.1
ARG TIMESCALE_TOOLKIT_VERSION=1.18.0
# error: No package matches 'postgresql-unit_16-7.9-1.rhel8.x86_64'
# the available version is postgresql-unit_16-7.9-1PGDG.rhel8.x86_64.rpm
# Therefore changing 7.91-1 to 7.9-1PGDG
ARG POSTGRESQL_UNIT_VERSION=7.9-1PGDG
ARG TAG=ubi8-${POSTGRES_MAJOR_VERSION}.${POSTGRES_MINOR_VERSION}-${POSTGIS_VERSION}-${CRUNCHY_IMAGE_VERSION}

# Find CrunchyData image versions here;
# https://www.crunchydata.com/developers/download-postgres/containers/postgresql15
FROM ${REGISTRY}/${IMAGE}:${TAG}

ARG POSTGRES_MAJOR_VERSION
ARG POSTGRES_MINOR_VERSION
ARG CRUNCHY_IMAGE_VERSION
ARG POSTGIS_VERSION
# ARG TIMESCALE_VERSION
# ARG TIMESCALE_TOOLKIT_VERSION
ARG POSTGRESQL_UNIT_VERSION

USER root

# RUN curl -sSL -o /etc/yum.repos.d/timescale_timescaledb.repo "https://packagecloud.io/install/repositories/timescale/timescaledb/config_file.repo?os=el&dist=8" && \
RUN curl -sSL -o /tmp/pgdg-redhat-repo-latest.noarch.rpm "https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm" && \
    rpm -ivh /tmp/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf --disablerepo=pgdg-common --disablerepo=pgdg15 --disablerepo=ubi-8-baseos-rpms --disablerepo=ubi-8-appstream-rpms --setopt=install_weak_deps=0 update -y && \
    microdnf --disablerepo=ubi-8-baseos-rpms --disablerepo=ubi-8-appstream-rpms --setopt=install_weak_deps=0 install -y \
        postgresql-unit_${POSTGRES_MAJOR_VERSION}-${POSTGRESQL_UNIT_VERSION}.rhel8.x86_64 && \
        # timescaledb-2-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION}-0.el8.x86_64 \
        # timescaledb-2-loader-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_VERSION}-0.el8.x86_64 \
        # timescaledb-toolkit-postgresql-${POSTGRES_MAJOR_VERSION}-${TIMESCALE_TOOLKIT_VERSION}-0.x86_64 && \
    rm /tmp/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf clean all

USER 26
