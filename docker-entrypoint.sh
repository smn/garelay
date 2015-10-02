#!/bin/bash

set -e

echo "=> Creating database"
mkdir -p /garelay && \
    cd /garelay && \
    django-admin migrate --noinput --settings=garelay.settings.production

# Create main Supervisord config file
echo "=> Creating supervisord config"
cat > /etc/supervisor/supervisord.conf <<-EOM
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
environment = DJANGO_SETTINGS_MODULE="garelay.settings.production"
directory = /garelay
redirect_stderr = true
EOM

# Celery
echo "=> Creating Celery supervisor config"
cat > /etc/supervisor/conf.d/celery.conf <<-EOM
[program:celery]
command = celery worker -A garelay -B --loglevel=INFO
environment = DJANGO_SETTINGS_MODULE="garelay.settings.production",GARELAY_SERVER=${GARELAY_SERVER}
directory = /garelay
redirect_stderr = true
EOM

echo "=> Reloading Supervisord"
supervisorctl reload

echo "=> Tailing logs"
multitail --mergeall --basename -f /var/log/supervisor/*.log
