# These values will be overriden by the values passed in from
# the Github Actions workflow file.
ARG REGISTRY=registry.developers.crunchydata.com/crunchydata
ARG IMAGE=crunchy-postgres-gis
ARG POSTGRES_MAJOR_VERSION=18
ARG POSTGRES_MINOR_VERSION=1
ARG POSTGIS_VERSION=3.6
ARG CRUNCHY_IMAGE_VERSION=2547
ARG POSTGRESQL_UNIT_VERSION=7.10-4PGDG
ARG TAG=ubi9-${POSTGRES_MAJOR_VERSION}.${POSTGRES_MINOR_VERSION}-${POSTGIS_VERSION}-${CRUNCHY_IMAGE_VERSION}

# Find CrunchyData image versions here:
# https://www.crunchydata.com/developers/download-postgres/containers/postgresql15
FROM ${REGISTRY}/${IMAGE}:${TAG}

ARG POSTGRES_MAJOR_VERSION
ARG POSTGRESQL_UNIT_VERSION

USER root

# TARGETARCH is automatically set by Docker BuildKit (amd64 or arm64)
ARG TARGETARCH

# Install postgresql-unit extension with architecture detection
RUN ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "aarch64" || echo "x86_64") && \
    echo "Building for architecture: $TARGETARCH (RPM arch: $ARCH)" && \
    curl -sSL -o /tmp/pgdg-redhat-repo-latest.noarch.rpm "https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-${ARCH}/pgdg-redhat-repo-latest.noarch.rpm" && \
    rpm -ivh /tmp/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf --disablerepo=pgdg-common --disablerepo=pgdg18 --disablerepo=ubi-9-baseos-rpms --disablerepo=ubi-9-appstream-rpms --setopt=install_weak_deps=0 update -y && \
    microdnf --disablerepo=ubi-9-baseos-rpms --disablerepo=ubi-9-appstream-rpms --setopt=install_weak_deps=0 install -y \
        postgresql-unit_${POSTGRES_MAJOR_VERSION}-${POSTGRESQL_UNIT_VERSION}.rhel9.${ARCH} && \
    rm /tmp/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf clean all

USER 26
