#!/bin/bash

superset db upgrade

superset fab create-admin \
            --username admin \
            --firstname Superset \
            --lastname Admin \
            --email admin@superset.com \
            --password ${SUPERSET_ADMIN_PASSWORD:-admin}

superset init

/usr/bin/run-server.sh