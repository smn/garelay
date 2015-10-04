#!/bin/bash
docker run \
    -it \
    --rm=true \
    -p 8001:8000 \
    -e GARELAY_SERVER=http://localhost:8000/server \
    --name garelay-tracker \
    -v /tmp:/garelay/ \
    garelay:`cat VERSION` tracker
