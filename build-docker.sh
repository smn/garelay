#!/bin/bash
docker build -t garelay:`cat VERSION` . && \
    docker run \
        -it \
        --rm=true \
        -p 8000:8000 \
        -e GARELAY_VERSION=`cat VERSION` \
        -e GARELAY_SERVER=http://localhost:8000/server \
        --name garelay \
        garelay:`cat VERSION` $@
