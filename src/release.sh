#!/bin/sh
set -x
set -e
version=`grep '^WINETRICKS_VERSION' < winetricks | sed 's/.*=//'`
echo Pushing version $version

tar -czvf winetricks-$version.tgz winetricks
sha1sum winetricks-$version.tgz > winetricks-$version.tgz.sha1.txt
scp winetricks-$version.tgz winetricks-$version.tgz.sha1.txt kegel.com:public_html/winetricks/download/releases/
scp winetricks kegel.com:public_html/winetricks/
