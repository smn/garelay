cd "${INSTALLDIR}/${NAME}/"
manage="${VENV}/bin/python ${INSTALLDIR}/${NAME}/manage.py"

$manage migrate --noinput --settings=garelay.settings.production

# process static files
$manage compress --settings=garelay.settings.production
$manage collectstatic --noinput --settings=garelay.settings.production

# compile i18n strings
$manage compilemessages --settings=garelay.settings.production
