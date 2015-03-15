[AddingNewVerbs#Applying\_Workarounds\_for\_Wine\_Bugs](AddingNewVerbs#Applying_Workarounds_for_Wine_Bugs.md) describes
the basics of adding known workarounds to winetricks verbs,
but doesn't tell you how to find new ones.

Finding workarounds for new Wine problems is an art, not a science.
Here are a few basic tips, plus examples of how it was done for
a few existing Winetricks verbs.

## Basic Tips ##

If you haven't read the FAQ yet, please do; see http://wiki.winehq.org/FAQ

If sound is broken, sometimes "winetricks dsoundhw=Emulated" (aka
using winecfg to set "DirectSound Hardware Acceleration" to "Emulation")
helps.  (This needs an FAQ entry and a bug still?!)

If you don't know why an app won't start, the log might help;
see http://wiki.winehq.org/FAQ#get_log

You may need to turn on particular debugging channels to get enough
info; see http://wiki.winehq.org/DebugChannels

## Examples ##

### Digitanks ###

This game crashed immediately on startup, showing just
```
fixme:dbghelp:elf_search_auxv can't find symbol in module
fixme:dbghelp:MiniDumpWriteDump NIY MiniDumpScanMemory
```
over and over again in the log.  Evidently it was crashing and
writing out minidump files over and over again.

I checked http://bugs.winehq.org and http://appdb.winehq.org,
but there was no mention of this game yet.

I trolled for clues by turning on the +file debug channel, e.g.
```
 WINEDEBUG=+file wine digitanks.exe > log.txt 2>&1
```
and then loading log.txt in my favorite text editor.

Not too many lines before the minidump line, I saw the line
```
trace:file:CreateFileW L"C:\\windows\\Fonts\\Arial.ttf" GENERIC_READ
FILE_SHARE_READ FILE_SHARE_WRITE  creation 3 attributes 0x80
```

Wine doesn't come with that file; you have to install it with
"winetricks corefonts".  And sure enough, that command got the game
to run.

Now that I knew the approximate cause of the crash, and had a workaround, I filed a bug report for it
( http://bugs.winehq.org/show_bug.cgi?id=26915 )
and added the lines

```
    if w_workaround_wine_bug 26915 "installing corefonts"
    then
        w_call corefonts
    fi
```

to the verb.  Case closed!