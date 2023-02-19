#!/bin/sh
# Trivial release helper for winetricks
#
# Usage: $0 optional_version_name
#
# Copyright (C) 2016 Austin English
#
# This software comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the GNU Lesser
# Public License version 2.1 (or later), as published by the Free
# Software Foundation. Please see the file COPYING for details.

set -e
#set -u
set -x

nopush=0
# Don't push commits/tags or upload files if --no-push is given:
if [ "$1" = "--no-push" ] ; then
    nopush=1
    shift
# If we _are_ pushing, we'll need a github token:
elif [ -z "${GITHUB_TOKEN}" ] ; then
    echo "--no-push wasn't given, GITHUB_TOKEN must be set in the environment!"
    exit 1
fi

# FIXME: If "--no-push" isn't set, above statement dies, not sure how to construct properly to avoid
set -u

# For a WINEPREFIX for winetricks list commands:
tmpdir="$(mktemp -d)"

# WINEPREFIX must be under a directory owned by user, so can't be in /tmp directly..
export WINEPREFIX="${tmpdir}/wineprefix"

# Set an empty cache so nothing shows as cached:
export W_CACHE="/dev/null"

# Set WINEARCH="win32" so we don't get 64-bit warning in output:
export WINEARCH="win32"

# Needed by the list commands below:
export WINETRICKS_LATEST_VERSION_CHECK="development"

# Make sure we're at top level:
if [ ! -f Makefile ] ; then
    echo "Please run this from the top of the source tree"
    exit 1
fi

version="${1:-$(date +%Y%m%d)}"

if git tag | grep -w "${version}" ; then
    echo "A tag for ${version} already exists!"
    exit 1
fi

# update version in winetricks itself
sed -i -e "s%WINETRICKS_VERSION=.*%WINETRICKS_VERSION=${version}%" src/winetricks

# update manpage
line=".TH WINETRICKS 1 \"$(date +"%B %Y")\" \"Winetricks ${version}\" \"Wine Package Manager\""
sed -i -e "s%\\.TH.*%${line}%" src/winetricks.1

# update LATEST (version) file
echo "${version}" > files/LATEST

# Update verb lists:
# actual categories
for category in $(./src/winetricks list); do
    ./src/winetricks "${category}" list | sed 's/[[:blank:]]*$//' > "files/verbs/${category}.txt"
done

# meta categories
./src/winetricks list-all | sed 's/[[:blank:]]*$//' > files/verbs/all.txt
./src/winetricks list-download | sed 's/[[:blank:]]*$//' > files/verbs/download.txt
./src/winetricks list-manual-download | sed 's/[[:blank:]]*$//' > files/verbs/manual-download.txt

git commit files/LATEST files/verbs/*.txt src/winetricks src/winetricks.1 -m "version bump - ${version}"
git tag -s -m "winetricks-${version}" "${version}"

# update development version in winetricks
sed -i -e "s%WINETRICKS_VERSION=.*%WINETRICKS_VERSION=${version}-next%" src/winetricks
git commit src/winetricks -m "development version bump - ${version}-next"

if [ ${nopush} = 1 ] ; then
    echo "--no-push used, not pushing commits / tags"
else
    git push
    git push --tags
fi

# create local tarball, identical to github's generated one
git -c tar.tar.gz.command='gzip -cn' \
    archive --format=tar.gz --prefix="winetricks-${version}/" \
    -o "${tmpdir}/${version}.tar.gz" "${version}"

# create a detached signature of the tarball
gpg --armor --default-key 0x267BCC1F053F0749 --detach-sign "${tmpdir}/${version}.tar.gz"

# upload the detached signature to github:
if [ ${nopush} = 1 ] ; then
    echo "--no-push used, not uploading signature file"
else
    python3 src/github-api-releases.py "${tmpdir}/${version}.tar.gz.asc" Winetricks winetricks "${version}"
    rm -rf "${tmpdir}"
fi

exit 0
