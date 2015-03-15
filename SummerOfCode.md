# Introduction #

Every summer, Google sponsors students to work on existing open source
projects.  If you would like to help the Wine project by contributing
to Winetricks, please read on.  (To contribute directly to Wine, see
http://wiki.winehq.org/SummerOfCode.)

Eventually, Wine will be able to run most Windows applications without
any fiddling.  In the meantime, Winetricks is there to work around
Wine bugs for users... and to submit high-quality problem reports to the
Wine developers, so the bugs can be fixed.

Adding support for a game or app to Winetricks means Posix shell scripting, Autohotkey scripting, and interacting with the Wine developers to report Wine bugs.  (See AddingNewVerbs.)

The result is not only a stronger Wine installer regression test, but also a whole lot of happy users.

Winetricks wasn't accepted into Google Summer of Code 2011, but
that doesn't mean we're not interested in students :-)

# About You #

Anybody who can program and cares about software quality
can contribute to Winetricks; all that's required is that you
not be allergic to shell scripting, and that you be willing
to test your work and file good bug reports when you find problems.
(If you're a C programmer and can actually improve Wine when you
find a shortcoming, even better... but that's not required to contribute
to Winetricks.)

If you're interested in working on Winetricks for Google Summer of Code,
please apply via http://code.google.com/soc, answering all the
questions in our ApplicationTemplate.
Before you apply, feel free to get in touch with us via our
[mailing list](http://groups.google.com/group/winetricks-dev).
To improve your chances of being selected, here are a few tips on
how to come up to speed:

# Getting Started as a Winetricks contributor #

  * familiarize yourself with [the Posix shell command language](http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html)
  * familiarize yourself with [Autohotkey](http://autohotkey.com)
  * try [Installing](Installing.md) Wine and Winetricks and testing some games with them
  * if you notice a bug in Wine, file a bug for it in [Wine's bugzilla](http://bugs.winehq.org)
  * if you notice a bug in Winetricks, file a bug for it in [Winetricks' issue tracker](http://code.google.com/p/winetricks/issues/list)
  * Actually try AddingNewVerbs

# Ideas #

Here are a few ideas for Summer of Code projects in Winetricks:

## 64 bit support ##

Winetricks currently only supports 32 bits.  An older release had partial
support for 64 bits; let's bring that back and add some 64 bit apps, too.

## Better support for non-English languages ##

This means adding more translated strings to the script,
as well as installing language-specific versions of apps.
See also http://code.google.com/p/winetricks/issues/detail?id=11

## Support a new game store ##

Winetricks already supports Steam and GOG.com (or will shortly),
but there are lots more places offering digital download of games,
e.g. [Amazon Game Downloads](http://www.amazon.com/s/ref=vg_nav_gd_allgames?ie=UTF8&search-alias=videogames&field-browse=979455011) or
[Direct2Drive](http://www.direct2drive.com/).  We need to figure out
a good way to support a game regardless of which service it's downloaded
from.

## Hyperlinked GUI ##

Winetricks uses Zenity for its GUI... just barely.  We would love
to be able to embed links in the GUI to web pages, e.g. the [wine appdb](http://appdb.winehq.org) or
[GameRankings](http://gamerankings.com) page for each game.
Surprisingly, Zenity may support this; see
http://www.gtk.org/api/2.6/pango/PangoMarkupFormat.html
for more details.

## Moar Games! ##

Winetricks supports only about 70 games at the moment... a small
fraction of the games that people want to run.
If you play a lot of Windows games, why not spend the summer making
it easy for people to run them on Linux, and helping the Wine
developers make them run better there?