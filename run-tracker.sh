#!/bin/bash
docker run \
    -it \
    --rm=true \
    -p 8001:8000 \
    -e GARELAY_SERVER=http://localhost:8000/server \
    -e DATABASE_URL=sqlite:////garelay/db-tracker.sqlite3 \
    --name garelay-tracker \
    garelay:`cat VERSION` tracker
