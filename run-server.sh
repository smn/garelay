#!/bin/bash
docker run \
    -it \
    --rm=true \
    -p 8000:8000 \
    --name garelay-server \
    -e DATABASE_URL=sqlite:////garelay/db-server.sqlite3 \
    garelay:`cat VERSION` server
