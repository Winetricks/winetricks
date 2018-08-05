#!/bin/sh
#
# This script is public domain.

# This script installs bashate by unpacking .deb files built for Ubuntu 18.04.
# This is intended to install/use bashate in TravisCI.

# Usage (.travis.yml):
#   ...
#   os:
#     - linux
#     - ...
#   sudo: required
#   dist: trusty
#   ...
#   addons:
#     apt:
#       packages:
#       - python-tz
#       - ...
#   ...
#   before_install:
#       - time sh ./misc/travis-install-bashate-deb.sh
#       - ...

set -eux

# "us-central1.gce.archive.ubuntu.com" is used by "apt" addon
# (See "Installing APT Packages" in logs), assuming it's fast
UBUNTU_POOL=http://us-central1.gce.archive.ubuntu.com/ubuntu/pool
DEB_BABEL_LOCALEDATA=$UBUNTU_POOL/main/p/python-babel/python-babel-localedata_2.4.0+dfsg.1-2ubuntu1_all.deb
DEB_BABEL=$UBUNTU_POOL/main/p/python-babel/python-babel_2.4.0+dfsg.1-2ubuntu1_all.deb
DEB_BASHATE=$UBUNTU_POOL/universe/p/python-bashate/python-bashate_0.5.1-1_all.deb
DEB_PBR=$UBUNTU_POOL/main/p/python-pbr/python-pbr_3.1.1-3ubuntu3_all.deb
DEB_SIX=$UBUNTU_POOL/main/s/six/python-six_1.11.0-2_all.deb

if command -v bashate >/dev/null; then
    echo "bashate is already installed."
    exit 1
fi

if test -d /Library; then
    # macOS: "six" is already installed
    curl --remote-name-all $DEB_BABEL_LOCALEDATA $DEB_BABEL $DEB_BASHATE $DEB_PBR
    BINDIR=/usr/local/bin
    PACKAGESDIR=/Library/Python/2.7/site-packages
else
    # Ubuntu
    curl --remote-name-all $DEB_BABEL_LOCALEDATA $DEB_BABEL $DEB_BASHATE $DEB_PBR $DEB_SIX
    BINDIR=/usr/bin
    PACKAGESDIR=/usr/lib/python2.7/dist-packages
fi

for f in *.deb; do
    ar p "$f" data.tar.xz | tar -Jvxf -
done

sudo cp -R usr/lib/python2.7/dist-packages/* $PACKAGESDIR/
sudo install -m 755 usr/bin/python2-bashate $BINDIR/bashate
