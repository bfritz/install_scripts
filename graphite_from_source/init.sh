#!/bin/sh

set -e

BASE_DIR="`pwd`"
INSTALL_DIR="$BASE_DIR/opt/graphite"

source env/bin/activate

# start carbon-cache process
"$INSTALL_DIR/bin/carbon-cache.py" start


# initialize graphite DB
#rm "$INSTALL_DIR/storage/graphite.db"

cd "$INSTALL_DIR/webapp/graphite"

python manage.py syncdb

# start gunicorn webserver
echo "Start web interface with:"
echo "source env/bin/activate"
echo gunicorn_django "$INSTALL_DIR/webapp/graphite/settings.py"
