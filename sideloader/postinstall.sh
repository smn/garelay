cd "${INSTALLDIR}/${NAME}/garelay/"
manage="${VENV}/bin/python ${INSTALLDIR}/${NAME}/garelay/manage.py"

$manage migrate --settings=garelay.settings.production

# process static files
$manage compress --settings=garelay.settings.production
$manage collectstatic --noinput --settings=garelay.settings.production

# compile i18n strings
$manage compilemessages --settings=garelay.settings.production
