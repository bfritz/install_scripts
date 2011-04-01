#!/bin/sh

set -e

BASE_DIR="`pwd`"
INSTALL_DIR="$BASE_DIR/opt/graphite"

#PROXY="--proxy localhost:8123"

bzr branch lp:graphite src
#rsync -avSP $HOME/projects/graphite/code/ src

# setup and activate virtualenv
virtualenv --no-site-packages --distribute env
source env/bin/activate

# install whisper
cd src/whisper
python setup.py install

# install carbon (setup.cfg removed so prefix can be set)
cd ../carbon
rm -f setup.cfg
python setup.py install --prefix="$INSTALL_DIR" --install-lib="$INSTALL_DIR/lib"


# configure carbon
sed -e "s#/opt/graphite#$INSTALL_DIR#" \
    < "$INSTALL_DIR/conf/carbon.conf.example" \
    > "$INSTALL_DIR/conf/carbon.conf"

cat <<EOF > "$INSTALL_DIR/conf/storage-schemas.conf"
[everything_1sec_for_10min_1min_for_2days_10min_for_5yrs]
priority = 100
pattern = .*
retentions = 1:600,60:2880,600,262800
EOF

# install third-party dependencies...
cd "$BASE_DIR"

# ...primarily via pip
pip install $PROXY django twisted txamqp gunicorn

# ...except for py2cario
curl -O http://cairographics.org/releases/py2cairo-1.8.10.tar.gz

mkdir -p env/build
cd env/build
tar xfz ../../py2cairo-1.8.10.tar.gz
cd pycairo-1.8.10
python waf configure --prefix="$VIRTUAL_ENV"
python waf build
python waf install

# install graphite webapp
cd "$BASE_DIR/src"
rm -f setup.cfg
python setup.py install --prefix="$INSTALL_DIR" --install-lib="$INSTALL_DIR/webapp"

