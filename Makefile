# Makefile for winetricks - a script for working around common problems in wine
#
# Copyright (C) 2013 Dan Kegel.  See also copyright notice in src/winetricks.
#
# winetricks comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the
# GNU Lesser Public License version 2.1, as published by the Free Software
# Foundation. Please see the file src/COPYING for details.
#
# Web Page: http://winetricks.org
#
# Maintainers:
# Dan Kegel <dank!kegel.com>, Austin English <austinenglish!gmail.com>

INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644
SOURCES = Makefile src tests

version=$(shell grep '^WINETRICKS_VERSION' < src/winetricks | sed 's/.*=//')

PREFIX = /usr/local

all:
	@ echo "Nothing to compile. Use: check, clean, cleanup, dist, install"

# Editor backup files etc.
clean:
	find . -name "*[#~]" \
		-o -name "*.\#*" \
		-o -name "*.orig" \
		-o -name "*.porig" \
		-o -name "*.rej" \
		-o -name "*.log" \
		-o -name "*.out" \
		-o -name "*.verbs" \
	| xargs --no-run-if-empty rm
	rm -f src/df-*

# Remove trailing whitespaces
cleanup:
	echo sed --in-place 's,[ \t]\+$$,,' $$(find $(SOURCES) -type f)

dist: clean $(SOURCES)
	tar --exclude='*.patch' --exclude=measurements --exclude=.svn \
		--exclude-backups \
		-czvf winetricks-$(version).tar.gz $(SOURCES)

install:
	$(INSTALL_PROGRAM) src/winetricks $(DESTDIR)$(PREFIX)/bin
	$(INSTALL_DATA) src/winetricks.1 $(DESTDIR)$(PREFIX)/man/man1

check:
	echo 'This verifies that most DLL verbs, plus flash, install ok.'
	echo 'If you want to test a particular version of wine, do e.g. '
	echo 'export WINE=$HOME/wine-git/wine first.'
	rm -rf ~/winetrickstest-prefixes
	cd src; sh ../tests/winetricks-test quick
