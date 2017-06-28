#!/bin/sh
#
# Script to bisect Wine regressions in Winetricks
#
# Usage: git bisect run $0 winetricks_command
#
# Copyright (C) 2017 Austin English
#
# This software comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the GNU Lesser
# Public License version 2.1 (or later), as published by the Free
# Software Foundation. Please see the file COPYING for details.

# This script should be used for bisecting wine regressions that affect winetricks
# For example, if dotnet20 works in wine-2.0, but not wine-2.2, use:
# $ cd $WINE-GIT
# $ git bisect start
# $ git bisect good wine-2.0
# $ git bisect bad wine-2.2
# Note: -q -v are automatically added
# $ git bisect run /path/to/this/script dotnet20

set -x

WINE_GIT="${WINE_GIT:-$HOME/wine-git}"

cd "$WINE_GIT" || exit 125

git clean -fxd || exit 125

./configure --disable-tests || exit 125

if command nproc >/dev/null 2>&1 ; then
    make "-j$(nproc)" || exit 125
else
    make -j2
fi

"${WINE_GIT}/server/wineserver" -k || true

rm -rf "$HOME/.wine" || exit 125

WINE="${WINE_GIT}/wine" winetricks -q -v "$@"
