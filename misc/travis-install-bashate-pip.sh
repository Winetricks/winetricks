#!/bin/sh
#
# This script is public domain.
#
# This file is intended to install bashate via pip.

set -ex

if test -d /Library; then
    # macOS
    curl https://bootstrap.pypa.io/get-pip.py | sudo python
else
    # Ubuntu
    sudo apt-get install python-pip
fi
sudo -H pip install bashate
