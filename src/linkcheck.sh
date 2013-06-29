#!/bin/sh
# Link checker for winetricks.
#
# Copyright (C) 2011,2012,2013 Dan Kegel.
#
# This software comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the
# GNU Lesser Public License version 2.1, as published by the Free Software
# Foundation. Please see the file COPYING for details.

datadir="links.d"

WINETRICKS_SOURCEFORGE=http://downloads.sourceforge.net
# ftp.microsoft.com resolves to two different IP addresses, one of which is broken
ftp_microsoft_com=64.4.17.176

w_download() {
    url="`echo $1 | sed -e 's,$ftp_microsoft_com,'$ftp_microsoft_com',;s,$WINETRICKS_SOURCEFORGE,'$WINETRICKS_SOURCEFORGE',;s, ,%20,g'`"
    echo url is "$url"
    urlkey="`echo "$url" | tr / _`"
    echo "$url" > "$datadir"/"$urlkey.url"
}

# Extract list of URLs from winetricks
extract_all() {
    grep '^ *w_download ' winetricks | sed 's/^ *//' | tr -d '\\' > url-script-fragment.tmp
    . ./url-script-fragment.tmp
}

# Show results for a given url
# Input: .url file
# Output: line with OK or BAD followed by URL,
# optionally followed by lines with more detail
show_one() {
    urlfile=$1
    base=${urlfile%.url}
    url="`cat $urlfile`"
    if grep "HTTP.*404" "$base.log"
    then
        echo "BAD $url"
        cat "$base.log"
        echo ""
    fi
}

# Show full report on most recent crawl
show_all() {
    for urlfile in "$datadir"/*.url
    do
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
    url="`cat $urlfile`"

    curl --connect-timeout 10 --retry 6 -s -S -I "$url" 2>&1 |
       tr -d '\015' |
       grep . |
       sort > "$base.log"
    # more diff-able?
    #cat "$base.log" |
    #  egrep 'HTTP|Last-Modified:|Content-Length:|ETag:' |
    #  tr '\012' ' ' |
    #  sed 's/ Connection:.*//' > "$datadir"/"$urlkey.dat"
    #echo "" >> "$base.dat"
    show_one "$urlfile"
}

# Fetch all info
# Do fetches in background so slow servers don't hang us
# Print quick feedback as results come in
crawl_all() {
    for urlfile in "$datadir"/*.url
    do
        url="`cat $urlfile`"
        echo "Crawling $url"
        crawl_one "$urlfile" &
        sleep 1
    done
    # Wait for fetches to finish
    wait
}

mkdir -p "$datadir"

case "$1" in
crawl)
    extract_all
    crawl_all
    show_all
    ;;
report)
    show_all
    ;;
esac
