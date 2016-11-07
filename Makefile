# Makefile for winetricks - a script for working around common problems in wine
#
# Copyright (C) 2013 Dan Kegel
# Copyright (C) 2015-2016 Austin English
# See also copyright notice in src/winetricks.
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

PREFIX = /usr

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
	rm -rf src/df-* src/measurements src/links.d

# Remove trailing whitespaces
cleanup:
	sed --in-place 's,[ \t]\+$$,,' $$(find $(SOURCES) -type f)

dist: clean $(SOURCES)
	tar --exclude='*.patch' --exclude=measurements --exclude=.git \
		--exclude-backups \
		-czvf winetricks-$(version).tar.gz $(SOURCES)

install:
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/bin
	$(INSTALL_PROGRAM) src/winetricks $(DESTDIR)$(PREFIX)/bin/winetricks
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/share/man/man1
	$(INSTALL_DATA) src/winetricks.1 $(DESTDIR)$(PREFIX)/share/man/man1/winetricks.1

check:
	echo 'This verifies that most DLL verbs, plus flash, install ok.'
	echo 'It should take about an hour to run with a fast connection.'
	echo 'If you want to test a particular version of wine, do e.g.'
	echo 'export WINE=$$HOME/wine-git/wine first.'
	echo 'On 64 bit systems, you probably want export WINEARCH=win32.'
	echo 'Winetricks does not work completely in non-English locales.'
	echo ''
	echo 'Current Environment:'
	echo 'DISPLAY is currently "$(DISPLAY)".'
	echo 'LANG is currently "$(LANG)".'
	echo 'WINEARCH is currently "$(WINEARCH)".'
	echo 'WINE is currently "$(WINE)".'
	echo 'XAUTHORITY is currently "$(XAUTHORITY)".'
	echo ''
	echo 'If running this as part of debuild, you might need to use'
	echo 'debuild --preserve-envvar=LANG --preserve-envvar=WINE --preserve-envvar=WINEARCH --preserve-envvar=DISPLAY --preserve-envvar=XAUTHORITY'
	echo 'To suppress tests in debuild, export DEB_BUILD_OPTIONS=nocheck'
	echo ''
	echo 'FIXME: this should kill stray wine processes before and after, but some leak through, you might need to kill them.'
	# Check for checkbashisms/shellcheck issues first:
	echo "Running checkbashisms/shellcheck:"
	sh ./tests/shell-checks || exit 1
	# Check all script dependencies before starting tests:
	echo "Checking dependencies.."
	sh ./src/linkcheck.sh check-deps || exit 1
	sh ./tests/winetricks-test check-deps || exit 1
	echo "Running tests"
	cd src; if test -z "$(WINEARCH)" ; then export WINEARCH=win32 ; fi ; sh ../tests/winetricks-test quick

shell-checks:
	echo "This runs shell checks only. Currently, these are checkbashisms and shellcheck."
	echo "This is relatively fast and doesn't download anything."
	sh ./tests/shell-checks || exit 1

test:
	echo 'This verifies that most DLL verbs, plus flash and dotnet, install ok.'
	echo 'It also makes sure that all URLs in winetricks work, so a fast uncapped internet connection is needed.'
	echo 'It should take about an hour to run with a fast connection.'
	echo 'If you want to test a particular version of wine, do e.g.'
	echo 'export WINE=$$HOME/wine-git/wine first.'
	echo 'On 64 bit systems, you probably want export WINEARCH=win32.'
	echo 'Winetricks does not work completely in non-English locales.'
	echo ''
	echo 'Current Environment:'
	echo 'DISPLAY is currently "$(DISPLAY)".'
	echo 'LANG is currently "$(LANG)".'
	echo 'WINEARCH is currently "$(WINEARCH)".'
	echo 'WINE is currently "$(WINE)".'
	echo 'XAUTHORITY is currently "$(XAUTHORITY)".'
	echo ''
	echo 'If running this as part of debuild, you might need to use'
	echo 'debuild --preserve-envvar=LANG --preserve-envvar=WINE --preserve-envvar=WINEARCH --preserve-envvar=DISPLAY --preserve-envvar=XAUTHORITY'
	echo 'To suppress tests in debuild, export DEB_BUILD_OPTIONS=nocheck'
	echo ''
	echo 'FIXME: this should kill stray wine processes before and after, but some leak through, you might need to kill them.'
	# Check for checkbashisms/shellcheck issues first:
	echo "Running checkbashisms/shellcheck:"
	sh ./tests/shell-checks || exit 1
	# Check all script dependencies before starting tests:
	echo "Checking dependencies.."
	sh ./src/linkcheck.sh check-deps || exit 1
	sh ./tests/winetricks-test check-deps || exit 1
	echo "Running tests"
	rm -rf src/links.d; cd src; sh linkcheck.sh crawl
	echo 'And now, the one hour run check.'
	if test ! -z "$(XDG_CACHE_HOME)" ; then rm -rf $(XDG_CACHE_HOME)/winetricks ; else rm -rf $(HOME)/.cache/winetricks ; fi
	cd src; if test -z "$(WINEARCH)" ; then export WINEARCH=win32 ; fi ; sh ../tests/winetricks-test full

xvfb-check:
	echo "xvfb runs make check, for verbs safe for it"
	cd src; if test -z "$(WINEARCH)" ; then export WINEARCH=win32 ; fi ; sh ../tests/winetricks-test xvfb-check
