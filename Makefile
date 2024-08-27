# Makefile for winetricks - a script for working around common problems in wine
#
# Copyright (C) 2013 Dan Kegel
# Copyright (C) 2015-2016 Austin English
# See also copyright notice in src/winetricks.
#
# This software comes with ABSOLUTELY NO WARRANTY.
#
# This is free software, placed under the terms of the GNU Lesser
# Public License version 2.1 (or later), as published by the Free
# Software Foundation. Please see the file COPYING for details.
#
# Web Page: https://github.com/Winetricks/winetricks
#
# Maintainers:
# Austin English <austinenglish!gmail.com>

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
	| xargs -r rm
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
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/share/applications
	$(INSTALL_DATA) src/winetricks.desktop $(DESTDIR)$(PREFIX)/share/applications/winetricks.desktop
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/share/metainfo
	$(INSTALL_DATA) src/io.github.winetricks.Winetricks.metainfo.xml $(DESTDIR)$(PREFIX)/share/metainfo/io.github.winetricks.Winetricks.metainfo.xml
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps
	$(INSTALL_DATA) src/winetricks.svg $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps/winetricks.svg
	$(INSTALL) -d $(DESTDIR)$(PREFIX)/share/bash-completion/completions
	$(INSTALL_DATA) src/winetricks.bash-completion $(DESTDIR)$(PREFIX)/share/bash-completion/completions/winetricks

check:
	echo 'This verifies that most DLL verbs install ok.'
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
	# Check for shellcheck issues first:
	echo "Running shellcheck:"
	sh ./tests/shell-checks || exit 1
	# Check all script dependencies before starting tests:
	echo "Checking dependencies.."
	sh ./src/linkcheck.sh check-deps || exit 1
	sh ./tests/winetricks-test check-deps || exit 1
	echo "Running tests"
	cd src; if test -z "$(WINEARCH)" ; then export WINEARCH=win32 ; fi ; sh ../tests/winetricks-test quick

check-coverage:
	WINETRICKS_ENABLE_KCOV=1 $(MAKE) check

shell-checks:
	echo "This runs shell checks only. Currently, this is mostly shellcheck."
	echo "This is relatively fast and doesn't download anything."
	sh ./tests/shell-checks || exit 1

test:
	echo 'This verifies that most DLL verbs install ok (and some other misc tests).'
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
	# Check for shellcheck issues first:
	echo "Running shellcheck:"
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

test-coverage:
	WINETRICKS_ENABLE_KCOV=1 $(MAKE) test

xvfb-check:
	echo "xvfb runs make check, for verbs safe for it"
	cd src; if test -z "$(WINEARCH)" ; then export WINEARCH=win32 ; fi ; sh ../tests/winetricks-test xvfb-check

xvfb-check-coverage:
	WINETRICKS_ENABLE_KCOV=1 $(MAKE) xfvb-check-coverage
