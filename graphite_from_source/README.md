# Install Graphite from Source to Current Directory

Installs [Graphite](http://graphite.wikidot.com/) from 
[source](https://code.launchpad.net/~graphite-dev/graphite/main)
into the current directory.  Graphite and carbon are cloned to
`src` and installed in `opt/graphite` under the current directory.
A Python virtualenv is created in `env` and Graphite's dependencies
are installed there.

`bootstrap.sh` handles the virtualenv setup, `bzr` checkout,
dependency installs (mostly via `pip`), and the graphite install.

`init.sh` starts the carbon daemon, adds an admin user (interactively)
via Django's `manage.py`, and echos the command to start the graphite
webapp under gunicorn.
