#!/bin/bash
docker run \
    -it \
    --rm=true \
    -p 8000:8000 \
    --name garelay-server \
    -v /tmp:/garelay/ \
    garelay:`cat VERSION` server
