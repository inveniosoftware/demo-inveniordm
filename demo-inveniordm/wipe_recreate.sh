#!/usr/bin/env sh
# -*- coding: utf-8 -*-
#
# Copyright (C) 2020 CERN.
#
# Demo-InvenioRDM is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

# Quit on errors
set -o errexit

# Quit on unbound symbols
set -o nounset

# Wipe
# ----

invenio shell --no-term-title -c "import redis; redis.StrictRedis.from_url(app.config['CACHE_REDIS_URL']).flushall(); print('Cache cleared')"
# NOTE: db destroy is not needed since DB keeps being created
#       Just need to drop all tables from it.
invenio db drop --yes-i-know
invenio index destroy --force --yes-i-know
invenio index queue init purge

# Recreate
# --------
# NOTE: db init is not needed since DB keeps being created
#       Just need to create all tables from it.
invenio db create
invenio files location create --default 'default-location'  $(pipenv run invenio shell --no-term-title -c "print(app.instance_path)")'/data'
invenio roles create admin
invenio access allow superuser-access role admin
invenio index init --force

# Add demo data
# -------------
invenio rdm-records demo
invenio vocabularies import languages licenses