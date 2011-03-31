#!/bin/sh
set -x
for url in ` grep '^ *w_download ' winetricks | sort | grep http | sed 's/^ *//' | awk '{print $2}' | tr -d '"'"'" `
do
    echo -n "$url "
    curl --connect-timeout 10 --retry 6 -s -S -I "$url" > tmp
    cat tmp >> tmp.all
    if test "`grep HTTP < tmp | grep " 200 " `" = ""
    then
        echo "----------"
        echo "$url bad"
        cat tmp
        echo ""
    fi
    cat tmp | egrep 'Last-Modified:|Content-Length:|ETag:' | tr '\012' ' ' | tr -d '\015' | sed 's/ Connection:.*//'
    echo ""
done > linkcheck.out

diff -u linkcheck.ref linkcheck.out

