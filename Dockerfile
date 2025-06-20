#-*- coding: utf-8 -*-
#
# This file is part of Invenio.
#
# Copyright (C) 2019-2022 CERN.
# Copyright (C) 2019-2020 Northwestern University.
#
# Invenio is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#
# Dockerfile that builds a fully functional image of your app.
#
# This image installs all Python dependencies for your application. It's based
# on Almalinux (https://github.com/inveniosoftware/docker-invenio)
# and includes Pip, Pipenv, Node.js, NPM and some few standard libraries
# Invenio usually needs.
#
# Note: It is important to keep the commands in this file in sync with your
# bootstrap script located in ./scripts/bootstrap.

FROM registry.cern.ch/inveniosoftware/almalinux:1

ENV KEYTAB_PATH '/var/lib/secrets'
ENV KERBEROS_TOKEN_PATH '/var/run/krb5-tokens'

RUN dnf install -y epel-release
RUN dnf update -y
# CRB (Code Ready Builder): equivalent repository to well-known CentOS PowerTools
RUN dnf install -y yum-utils
RUN dnf config-manager --set-enabled crb

# Volume where to mount the keytab as a secrets
# If credentials are passed as username and password with
# KEYTAB_USER and KEYTAB_PWD environment variables, a keytab will be
# generated and stored in KEYTAB_PATH.
RUN dnf install -y kstart krb5-workstation
# volume needed for the token file
VOLUME ["${KERBEROS_TOKEN_PATH}"]

RUN mkdir -p $KEYTAB_PATH && chmod a+rw $KEYTAB_PATH

# todo: add standford package repo when available, epel-release provides only the latest
# xrootd release
ARG xrootd_version=""
RUN if [ ! -z "$xrootd_version" ] ; then XROOTD_V="-$xrootd_version" ; else XROOTD_V="" ; fi && \
    echo "Will install xrootd version: $XROOTD_V (latest if empty)" && \
    dnf install -y xrootd"$XROOTD_V" python3-xrootd"$XROOTD_V"

COPY Pipfile Pipfile.lock ./
RUN pipenv install --deploy --system
RUN pip install invenio-xrootd">=2.0.0a1"

COPY ./docker/uwsgi/ ${INVENIO_INSTANCE_PATH}
COPY ./invenio.cfg ${INVENIO_INSTANCE_PATH}
COPY ./templates/ ${INVENIO_INSTANCE_PATH}/templates/
COPY ./app_data/ ${INVENIO_INSTANCE_PATH}/app_data/
COPY ./translations/ ${INVENIO_INSTANCE_PATH}/translations/
COPY ./ .

RUN cp -r ./static/. ${INVENIO_INSTANCE_PATH}/static/ && \
    cp -r ./assets/. ${INVENIO_INSTANCE_PATH}/assets/ && \
    invenio collect --verbose && \
    invenio webpack buildall

# application build args to be exposed as environment variables
ARG IMAGE_BUILD_TIMESTAMP
ARG SENTRY_RELEASE

# Expose random sha to uniquely identify this build
ENV INVENIO_IMAGE_BUILD_TIMESTAMP="'${IMAGE_BUILD_TIMESTAMP}'"
ENV SENTRY_RELEASE=${SENTRY_RELEASE}

RUN echo "Image build timestamp $INVENIO_IMAGE_BUILD_TIMESTAMP"

ENTRYPOINT [ "bash", "-c"]
