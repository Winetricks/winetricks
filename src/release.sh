#!/bin/sh
set -x
set -e
version=`grep '^WINETRICKS_VERSION' < winetricks | sed 's/.*=//'`
echo Pushing version $version

# FIXME: Should adjust version and date in man page?
# FIXME: making the tarball should probably be the responsibility of 'make tarball'
tar -czvf winetricks-$version.tgz winetricks winetricks.1 COPYING
sha1sum winetricks winetricks-$version.tgz > winetricks-$version.tgz.sha1.txt
scp winetricks-$version.tgz winetricks-$version.tgz.sha1.txt kegel.com:public_html/winetricks/download/releases/
scp winetricks kegel.com:public_html/winetricks/
