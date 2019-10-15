#!/bin/sh
#
# Copyright (C) 2019 Austin English
# See also copyright notice in src/winetricks.
#
# This software comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the GNU Lesser
# Public License version 2.1 (or later), as published by the Free
# Software Foundation. Please see the file COPYING for details.

# build helloworld.exe for each version of C# that mono supports
# so that they can be used by winetricks-test/verify_*() in winetricks itself
# Tested with `Mono C# compiler version 6.0.0.313`

if [ ! -x "$(command -v mcs 2>/dev/null)" ]; then
    echo "mcs must be installed to compile test binaries"
    exit 1
fi

for dotnet_version in 2.0 3.0 4.0 4.5 4.6 4.7; do
    # C# version to .Net version info can be found at:
    # https://www.guru99.com/c-sharp-dot-net-version-history.html

    case "$dotnet_version" in
        # unsupported by mono, even though it's in the manpage..:
        1.0) echo "Not supported by mcs"; exit 1;;

        2.0) lang_version="ISO-2";;

        # FIXME: There's no 3.0-api, but there is 3.5-api. Tried
        # -nostdlib -r:/usr/lib/mono/2.0-api/mscorlib.dll -r:/usr/lib/mono/3.5-api/Microsoft.Build.Engine.dll -langversion:3
        # (as well as other dlls in there), but still got a 2.0 binary (i.e., it ran with dotnet20)
        3.0*) api_version="2.0"; lang_version="3";;

        4.0*) lang_version="4";;
        4.5*) lang_version="5";;
        4.6*) lang_version="6";;

        # FIXME: this version will change as mono supports newer versions, ideally should find a more stable solution.
        4.7*) lang_version="experimental";;

        4.8) echo "Not supported yet"; exit 1;;
        *) echo "unknown version"; exit 1;;
    esac

    # For arch: "The possible values are: anycpu, anycpu32bitpreferred, arm, x86, x64 or itanium. The default option is anycpu."
    for arch in x86 x64; do
        output="${dotnet_version}-${arch}.exe"
        api="${api_version:-$dotnet_version}"

        echo "Building ${output} for arch=${arch}, api=${api}, langversion=${lang_version}"
        mcs -nostdlib "-r:/usr/lib/mono/${api}-api/mscorlib.dll"  "-out:${output}" "-platform:${arch}" "-langversion:${lang_version}" hello-world.cs
    done

    unset api_version lang_version
done
