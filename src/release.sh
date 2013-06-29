#!/bin/sh
# Trivial release helper for winetricks.
#
# Copyright (C) 2011,2012,2013 Dan Kegel.
#
# This software comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the
# GNU Lesser Public License version 2.1, as published by the Free Software
# Foundation. Please see the file COPYING for details.
set -x
set -e
version=`grep '^WINETRICKS_VERSION' < src/winetricks | sed 's/.*=//'`
echo Pushing version $version

# FIXME: Should adjust version and date in man page?
make dist
sha1sum src/winetricks winetricks-$version.tar.gz | sed 's,src/,,' > winetricks-$version.tar.gz.sha1.txt
scp winetricks-$version.tar.gz winetricks-$version.tar.gz.sha1.txt kegel.com:public_html/winetricks/download/releases/
scp src/winetricks kegel.com:public_html/winetricks/
