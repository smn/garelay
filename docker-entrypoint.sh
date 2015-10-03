#!/bin/bash

set -e

if [ "$1" = 'tracker' ]; then
    DJANGO_SETTINGS_MODULE=garelay.tracker.settings
elif [ "$1" = 'server' ]; then
    DJANGO_SETTINGS_MODULE=garelay.server.settings
else
    cat <<-EOM


Google Analytics Relay not starting!
====================================

No argument provided, please specify 'tracker' or 'server'
as the first positional argument.

Usage: docker run garelay:$GARELAY_VERSION [ tracker | server ]

EOM
    exit
fi

echo "=> Creating database"
mkdir -p /garelay && \
    cd /garelay && \
    django-admin migrate --noinput --settings=$DJANGO_SETTINGS_MODULE

# Create main Supervisord config file
echo "=> Creating supervisord config"

mkdir -p /etc/supervisor/conf.d/ && \
    mkdir -p /var/log/supervisor && \

cat > /etc/supervisord.conf <<-EOM
; supervisor config file

[unix_http_server]
file=/var/run/supervisor.sock   ; (the path to the socket file)
chmod=0700                       ; sockef file mode (default 0700)

[supervisord]
logfile=/var/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
childlogdir=/var/log/supervisor            ; ('AUTO' child log dir, default $TEMP)

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock ; use a unix:// URL  for a unix socket

; The [include] section can just contain the "files" setting.  This
; setting can list multiple files (separated by whitespace or
; newlines).  It can also contain wildcards.  The filenames are
; interpreted as relative to this file.  Included files *cannot*
; include files themselves.

[include]
files = /etc/supervisor/conf.d/*.conf
EOM

# Redis
echo "=> Creating Redis supervisor config"
cat > /etc/supervisor/conf.d/redis.conf <<-EOM
[program:redis]
command = redis-server
directory = /
redirect_stderr = true
EOM

# Tracker
echo "=> Creating Tracker supervisor config"
cat > /etc/supervisor/conf.d/garelay.conf <<-EOM
[program:garelay]
command = gunicorn --bind 0.0.0.0:${GARELAY_PORT} garelay.wsgi
environment = DJANGO_SETTINGS_MODULE="$DJANGO_SETTINGS_MODULE"
directory = /garelay
redirect_stderr = true
EOM

# Celery
echo "=> Creating Celery supervisor config"
cat > /etc/supervisor/conf.d/celery.conf <<-EOM
[program:celery]
command = celery worker -A garelay -B --loglevel=INFO
environment = DJANGO_SETTINGS_MODULE="$DJANGO_SETTINGS_MODULE",GARELAY_SERVER=${GARELAY_SERVER}
directory = /garelay
redirect_stderr = true
EOM

echo "=> Starting Supervisord"
supervisord -c /etc/supervisord.conf

echo "=> Tailing logs"
multitail --mergeall --basename -f /var/log/supervisor/*.log
