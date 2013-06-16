# Copyright (C) 2013, Dan Kegel
# LGPLv2.1
INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644
SOURCES = Makefile src tests debian

version=$(shell grep '^WINETRICKS_VERSION' < src/winetricks | sed 's/.*=//')

dist: $(SOURCES)
	tar -czvf winetricks-$(version).tar.gz $(SOURCES)

PREFIX = /usr/local

install:
	$(INSTALL_PROGRAM) src/winetricks $(DESTDIR)$(PREFIX)/bin
	$(INSTALL_DATA) src/winetricks.1 $(DESTDIR)$(PREFIX)/man/man1

check:
	echo 'This verifies that most DLL verbs, plus flash, install ok.'
	echo 'If you want to test a particular version of wine, do e.g. '
	echo 'export WINE=$HOME/wine-git/wine first.'
	rm -rf ~/winetrickstest-prefixes
	cd src; sh ../tests/winetricks-test quick
