#!/bin/sh
# Link checker for winetricks.
#
# Copyright (C) 2011,2012,2013 Dan Kegel.
#
# This software comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the GNU Lesser
# Public License version 2.1 (or later), as published by the Free
# Software Foundation. Please see the file COPYING for details.

set -e

passes=0
errors=0

check_deps() {
    if ! test -x "$(command -v curl 2>/dev/null)"; then
        echo "Please install curl"
        exit 1
    fi
}

if [ -f README.md ] ; then
    TOP="$PWD"
elif [ -f ../README.md ] ; then
    TOP=".."
else
    echo "Dude, where's my car?!"
    exit 1
fi

datadir="${TOP}/output/links.d"
mkdir -p "${datadir}"

WINETRICKS_SOURCEFORGE=https://downloads.sourceforge.net
# ftp.microsoft.com resolves to two different IP addresses, one of which is broken
ftp_microsoft_com=64.4.17.176

w_download() {
    # shellcheck disable=SC2016
    url="$(echo "$1" | sed -e 's,$ftp_microsoft_com,'$ftp_microsoft_com',;s,$WINETRICKS_SOURCEFORGE,'$WINETRICKS_SOURCEFORGE',;s, ,%20,g')"
    urlkey="$(echo "$url" | tr / _)"
    echo "$url" > "${datadir}/${urlkey}.url"
}

# Extract list of URLs from winetricks
extract_all() {
    # w_linkcheck_ignore=1 is a stupid hack to tell linkcheck.sh to ignore a URL (e.g., because it contains a variable)
    # Ideally, avoid using the variable, but we can't e.g., for dxvk
    # Should not be used for https://example.com/${file1}, as otherwise we can't easily check if the URL is down

    # https://github.com/koalaman/shellcheck/issues/861
    # shellcheck disable=SC1003
    grep '^ *w_download ' winetricks | grep -E 'ftp|http|WINETRICKS_SOURCEFORGE' | grep -v "w_linkcheck_ignore=1" | sed 's/^ *//' | tr -d '\\' > url-script-fragment.tmp

    # shellcheck disable=SC1091
    . ./url-script-fragment.tmp
}

# Show results for a given url
# Input: .url file
# Output: line with OK or BAD followed by URL,
# optionally followed by lines with more detail
show_one() {
    urlfile=$1
    base=${urlfile%.url}
    url="$(cat "$urlfile")"
    if grep -E "HTTP.*200|HTTP.*30[0-9]|Content-Length" "$base.log" > /dev/null; then
        passes=$((passes + 1))
    else
        echo "BAD $url"
        cat "$base.log"
        echo ""
        errors=$((errors + 1))
    fi
}

# Show full report on most recent crawl
show_all() {
    for urlfile in "$datadir"/*.url ; do
        show_one "$urlfile"
    done
}

# Save info about the given url to a file
# Input: .url file
# Output:
# .log gets the full info
# .dat gets a summary
# Calls show_one to print results out as they come in
crawl_one() {
    urlfile=$1
    base=${urlfile%.url}
    url="$(cat "$urlfile")"

    curl --connect-timeout 10 --retry 6 -s -S -I "$url" 2>&1 |
        tr -d '\015' |
        grep . |
        sort > "$base.log"
    # more diff-able?
    # cat "$base.log" |
    #  grep -E 'HTTP|Last-Modified:|Content-Length:|ETag:' |
    #  tr '\012' ' ' |
    #  sed 's/ Connection:.*//' > "$datadir"/"$urlkey.dat"
    # echo "" >> "$base.dat"
    show_one "$urlfile"
}

# Fetch all info
# Do fetches in background so slow servers don't hang us
# Print quick feedback as results come in
crawl_all() {
    for urlfile in "$datadir"/*.url ; do
        url="$(cat "$urlfile")"
        echo "Crawling $url"
        crawl_one "$urlfile" &
        sleep 1
    done
    # Wait for fetches to finish
    wait
}

mkdir -p "$datadir"

case "$1" in
check-deps)
    check_deps
    exit $?
    ;;
crawl)
    check_deps
    extract_all
    crawl_all
    show_all
    ;;
report)
    show_all
    ;;
*) echo "Usage: linkcheck.sh crawl|report"; exit 1;;
esac

# cleanup
rm -rf "$datadir" url-script-fragment.tmp
echo "Test over, $errors failures, $passes successes."
if test $errors = 0 && test $passes -gt 0
then
    echo PASS
    exit 0
else
    echo FAIL
    exit 1
fi
