#!/bin/sh
#
# Copyright (C) 2017 Austin English
#
# This software comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the GNU Lesser
# Public License version 2.1 (or later), as published by the Free
# Software Foundation. Please see the file COPYING for details.

# Note: This script is GNU/Linux (coreutils) specific. It's intended as a one-off,
# and shouldn't be needed for OSX/FreeBSD/Solaris, it should only be used by the maintainer.
#
# Purpose: for every file in $WINETRICKS_CACHE, convert checksum from sha1 to sha256
# Ideally, run some command/script that populates a lot of verbs, e.g., make test
#
# Other criteria:
# One package per commit
# If package has already been converted, should be a no-op
# Echo failing packages to a log file, and ignore, for manual review

set -x

CACHE_DIR="${HOME}/.cache/winetricks"
SRC_DIR="$PWD"
winetricks="${SRC_DIR}/src/winetricks"

if [ ! -f README.md ] ; then
    echo "Please run from the top level directory"
    exit 1
fi

# Gather list of packages and their checksums

logdir="${SRC_DIR}/sha-convert-logs"
rm -rf "${logdir}"
mkdir -p "${logdir}"

for dir in "${CACHE_DIR}/"* ; do
    # Skip LATEST/etc.
    if [ ! -d "${dir}" ] ; then
        continue
    fi

    package="$(basename "${dir}")"

    case "${package}" in
        win2ksp4|win7sp1|xpsp3|winxpsp3) continue ;;
    esac

    for file in "${dir}"/* ; do
        # Convert the package:
        echo file="${file}"
        echo "dir=$dir, package=$package, file=$file"
        sha1_file="$(sha1sum "${file}" | awk '{print $1}')"
        sha256_file="$(sha256sum "${file}" | awk '{print $1}')"
        echo "sha1: ${sha1_file}"
        echo "sha256: ${sha256_file}"
        sed -i "s!${sha1_file}!${sha256_file}!" "${winetricks}"
    done

    # Did it change?
    if git diff-index --quiet HEAD -- ; then
        echo "no diff detected"
        continue
    fi

    # Test it
    wineserver -k || true
    rm -rf "$HOME/.wine"

    # shellcheck disable=SC2115
    rm -rf "${CACHE_DIR}/${package}"

    # Not everything is actually quiet, of course..
    "${winetricks}" -q -v "${package}"
    test_status="$?"

    # Commit it (if it worked):
    if [ $test_status = 0 ] ; then
        git commit -m "${package}: convert to sha256" "${winetricks}"
    else
        git checkout -f
        echo "converting ${package} to sha256 failed" >> "${logdir}/conversion.log"
        continue
    fi

done

if [ "$(find "${logdir}" -type f | wc -l)" = 0 ] ; then
    rm -rf "${logdir}"
else
    echo "There were errors, check logs in ${logdir}"
    exit 1
fi
