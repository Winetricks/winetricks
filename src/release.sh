#!/bin/sh
set -x
set -e
version=`grep '^WINETRICKS_VERSION' < winetricks | sed 's/.*=//'`
echo Pushing version $version

cp winetricks winetricks-$version
gzip < winetricks-$version > winetricks-$version.gz
sha1sum winetricks-$version > winetricks-$version.sha1.txt
sha1sum winetricks-$version.gz > winetricks-$version.gz.sha1.txt
scp winetricks-$version winetricks-$version.gz winetricks-$version.sha1.txt winetricks-$version.gz.sha1.txt kegel.com:public_html/winetricks/download/releases/
scp winetricks kegel.com:public_html/kegel/wine/
