

## First Steps ##

Winetricks verbs are mostly just little shell scripts.  (See also LearningAboutShellScripting.)

Try this: open a terminal window, create a small text file called foo.verb,
and put the single line

```
echo Testing, testing, 1 2 3
```

Then run it by typing the command
```
sh foo.verb
```
into the terminal window.

You should see the output
```
Testing, testing, 1 2 3
```

Now try running it with winetricks:
```
winetricks foo.verb
```

You should see the output
```
Testing, testing, 1 2 3
Unknown arg foo
Usage: winetricks [options] [verb|path-to-verb] ...
...
```

Poor Winetricks was a little confused by that simple verb, but you can
see that it did run it.

The next section shows a more real, but still simple, winetricks verb.

## Hello, Winetricks ##

Here's a very simple winetricks verb:

```
w_metadata osmos_example games \
    title="Osmos demo example"

load_osmos_example()
{
    w_download http://gamedaily.newaol.com/pub/OsmosDemo_Installer_1.5.6.exe 7568f97100a73985a0fd625b63b205f4477578e8
    cd "$W_CACHE/$W_PACKAGE"
    $WINE OsmosDemo_Installer_1.5.6.exe
}
```

All it does is download (using the function [w\_download](Functions#w_download.md)) and install the demo for the game Osmos.

## Verb Metadata ##

The [w\_metadata](Functions#w_metadata.md) line tells winetricks about the verb.
The above example, though, it doesn't tell winetricks all it should.
A more complete version would look more like this:

```
w_metadata osmos_example games \
    title="Osmos demo example" \
    publisher="Hemisphere Games" \
    year="2009" \
    media="download" \
    file1="OsmosDemo_Installer_1.5.6.exe" \
    installed_exe1="$W_PROGRAMS_X86_WIN/OsmosDemo/OsmosDemo.exe"
```

  * **descriptive fields** are shown in the user interface and help with sorting.
  * **file1** identifies the filename of a downloadable installer, so winetricks can know if it needs to download more.  (Or, for a DVD game, **file1** is the volume name of the first disc plus ".iso".)
  * **installed\_exe1** (or **installed\_file1**) is a path to a file the verb installs.  Winetricks uses it as a shortcut for knowing if a verb has already been run, and skips over the load function if it has.  This can be especially helpful for dependency installation into existing prefixes.

Try to follow the existing standards for naming verbs.  Demos, for instance, should end with _demo_

## Verb Body ##

The shell function that follows the w\_metadata line is the
body of the verb, responsible for mounting or downloading the
installer, running it, and waiting for it to finish.

It has to be named load\_XXXX, where XXXX is the name announced
in the call to w\_metadata.

See [Functions](Functions.md) for a list of all the functions verb bodies can call.

## Testing your verb ##

You can try out the above example by putting it into a file named
osmos\_example.verb, then running the command
```
winetricks osmos_example.verb
```

(The filename has to match the name given to w\_metadata,
which has to match the load\_XXXX function that makes up the verb body.)

This should install it into the default wineprefix (~/.wine).

Try it now!

Make sure that...
  * winetricks doesn't return until the installer is really done
  * the verb shows up in 'winetricks XXXX.verb list-cached' after you install it.  (If it doesn't, you probably got the file1 metadata wrong.)   **the verb shows up in 'winetricks XXXX.verb list-installed' after you install it.  (If it doesn't, you probably got the installed\_exe1 metadata wrong.)
  * the game actually runs well without any hacks or workarounds**

list-cached and list-installed won't really know about the verb until
it is integrated into winetricks itself.  (Putting XXXX.verb on
the commandline before list-cached and list-installed is too
awkward for real use, it's just for testing.)

## Applying Workarounds for Wine Bugs ##

If wine has a bug that keeps your game from running well,
but there is an easy workaround, you should automate the
workaround.  For instance, before wine version 1.3.8, Osmos
required the Visual C++ 2005 runtime libraries because of
[Wine bug 24416](http://bugs.winehq.org/show_bug.cgi?id=24416).
You can automate that workaround when needed with the lines

```
    if w_workaround_wine_bug 24416 "installing C runtime library" 1.3.8,
    then
        w_call vcrun2005
    fi
```

The [w\_workaround\_wine\_bug](Functions#w_workaround_wine_bug.md) test requires a wine bug number;
these are the numbers referred to by [Wine's bugzilla](http://bugs.winehq.org) and [Wine's App Database](http://appdb.winehq.org).
The next parameter is an optional description of the workaround.
Finally, if the bug is fixed in some versions of wine,
indicate which ones by giving a range of version numbers,
separated by a comma.  "1.2," means "fixed in wine-1.2 and later".
",1.3.2" means "worked in all versions before 1.3.3, but broken in 1.3.3 and later".  "1.3.1,1.3.4" means "worked for a brief shining moment starting with wine-1.3.1 and ending with wine-1.3.4".

It's a bit of a chore finding the exact bug number, and
half the time you have to file a new bug to get that number.
But it's worth it, because that helps the Wine developers realize
they need to fix the problem, and because later, once the bug
is fixed, the verb can be updated to not apply the workaround
in fixed versions of wine.

See TamingTroublesomeTitles for some tips on finding workarounds.

## Installers that don't wait ##

If winetricks finishes before the installer is done, that
probably means you need to use [ahk\_do](Functions#ahk_do.md) to run an [Autohotkey](http://www.autohotkey.com/) script
to wait for the installer to finish.
For instance, in the above example, instead of
```
    $WINE OsmosDemo_Installer_1.5.6.exe
```
you could do
```
    w_ahk_do "
        run OsmosDemo_Installer_1.5.6.exe
        winwait, Osmos Demo Setup, Installation Complete
        WinWaitClose
    "
```

## Installing from DVD ##

First, make sure you can mount the disc :-)   Usually, gnome does this for
you automatically.  If you're using KDE, you may have to coax its file
manager into doing it by clicking on its icon for the disc.

To install a non-steam title from a single DVD,
you need to know its volume name.  You can get this in several ways:
  * look at KDE or Gnome's file manager or desktop icon for the disc
  * use the command 'volname /dev/sr0'  (doesn't always work)
  * use the command 'sh winetricks volnameof=/dev/sr0'

You use this volume name in two places:
  * in w\_metadata, set file1=VOLNAME.iso
  * at top of your load function, call w\_mount VOLNAME

Then run the game's installer as usual, except instead of cd'ing to
the cache, run it as ${W\_ISO\_MOUNT\_LETTER}:setup.exe.

See the deadspace verb for a good example.

Installing from multiple discs is a bit more complicated, see the diablo2 verb

Installing a Steam title from DVD is experimental; for now, do
> STEAM\_DVD=1
before calling w\_steam\_install\_game.

## Unattended Mode ##

Unattended mode is optional.  Most users won't need this.  You should
skip this the first few times you contribute winetricks verbs.

If you want the verb to be run by the winetricks automated regression
test, you'll need to support unattended mode.  If you're lucky, this means
passing the right commandline options to the installer.
See [unattended.sf.net](http://unattended.sourceforge.net/installers.php) for tips on common commandline options to enable unattended (sometimes
called silent) mode.

If you're unlucky, this means using AutoHotkey to click buttons for
the user.

Look at some of the existing verbs in winetricks to see how
they do it.  Osmos uses AutoHotkey to click buttons for the user;
office2007pro and penpenxmas use magic commandline options.

## Contributing your verb ##

Once you get a verb working, you can contribute it to Winetricks by
sending it to the winetricks-dev mailing list, or by attaching
it to a new issue in the issue tracker at http://winetricks.org.

Thanks!