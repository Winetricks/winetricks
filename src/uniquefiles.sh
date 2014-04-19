#!/bin/sh
# Script to locate unique files useful for install checks
set -e

if ! test $1
then
    echo "Please specify a bunch of wineprefixes to grub through"
    echo "For instance, ~/winetrickstest-prefixes/dotnet20sp{,1,2}"
    exit 1
fi
 
# Generate list of all filenames (except those which look ephemeral)
rm -f /tmp/allfiles.txt
for dir
do
    (
    cd $dir/drive_c
    # FIXME: don't assume there are no ='s in filenames, e.g. rewrite in perl
    find * -type f | tr ' ' '=' | egrep -iv 'tmp|temp|installer|NativeImages' | sort > ../files.txt
    cat ../files.txt >> /tmp/allfiles.txt
    )
done

# Find filenames that occur only once
sort < /tmp/allfiles.txt | uniq -c | awk '$1 == 1 {print $2}' > /tmp/uniqfiles.txt

# Associate them with the verb they came from
for dir
do
    (
    cd $dir
    # Undo the space-to-= transformation, too
    fgrep -f /tmp/uniqfiles.txt < files.txt | tr '=' ' ' > uniqfiles.txt
    )
    echo $dir/uniqfiles.txt
done
