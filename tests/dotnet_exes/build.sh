#!/bin/sh
#
# This script builds helloworld.exe for each version of C# that mono supports
# so that they can be used by winetricks-test/verify_*() in winetricks itself
#
# Copyright (C) 2020 Austin English
#
# This software comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the GNU Lesser
# Public License version 2.1 (or later), as published by the Free
# Software Foundation. Please see the file COPYING for details.

if ! command -v mcs; then
    echo "mcs (Mono C# compiler) is required to build dotnet binary tests"
    exit 1
fi

# FIXME 7/7.1/7.2 may be valid as well?
for version in ISO-2 3 4 5 6 experimental; do
    # C# version to .Net version info can be found at:
    # https://www.guru99.com/c-sharp-dot-net-version-history.html

    case "$version" in
    ISO-2) dn_ver="2.0"; extra_args="-r:/usr/lib/mono/3.5-api/mscorlib.dll";;
    3) dn_ver="3.0"; extra_args="";;
    4) dn_ver="4.0"; extra_args="";;
    5) dn_ver="4.5"; extra_args="";;
    6) dn_ver="4.6"; extra_args="";;

    # 7
    # 7.1
    # 7.2

    # FIXME: this will change as mono supports newer versions, ideally should find
    # a more stable solution.
    experimental) dn_ver="4.7-experimental"; extra_args="";;

    *) echo "unknown version"; exit 1;;
    esac

    # For arch: "The possible values are: anycpu, anycpu32bitpreferred, arm, x86, x64 or itanium. The default option is anycpu."
    for arch in x86 x64; do
        output="dotnet-hello-world-${dn_ver}-${arch}.exe"
        echo "Building ${output} for C# version ${version} / arch=${arch}"

        mcs -nostdlib "$extra_args" "-langversion:${version}" "-out:${output}" "-platform:${arch}" hello-world.cs
    done
done
