Here is an alphabetical list of the functions available to winetricks verb authors.
(Common Unix commands like cp, mv, and the like are also available.)



## w\_ahk\_do ##
Execute an Autohotkey script.

Autohotkey is a GUI scripting language.
In Winetricks, is is usually used to wait for an installer to finish, and/or to answer questions on behalf of the user when running in unattended install mode.

(See http://autohotkey.com for more info about Autohotkey.)

Here's an example that shows launching an app and waiting for it to finish:

```
w_ahk_do "
    run winemine.exe
    winwait WineMine
    winwaitclose
"
```

FIXME: write and link to a wiki page on how to use autohotkey

Note: you can't use quoted strings inside a w\_ahk\_do inline script.
Contact us if this is a problem for you.

## w\_append\_path ##

Add a directory to the windows PATH environment variable.

Only used when installing commandline utilities like mingw.

Example:
```
w_append_path 'C:\MinGW\bin'
```

## w\_call ##
Call another winetricks verb.  Abort if it fails

Example:
```
w_call mfc42
w_call mwo=force
```

## w\_declare\_exe ##
Tell Winetricks how to run an app.

All verbs that install apps or games should end with this.

Example:
```
w_declare_exe "$W_PROGRAMS_X86_WIN\\Runic Games\\Torchlight" Torchlight.exe
```

At the moment, this creates a batch file c:\run-$package.bat.  (This might change later, since win7 doesn't allow writing into c:\.)

## w\_die ##
Display the given error message and abort.

Example:
```
w_die "Please uninstall the Samyak font and try again."
```

## w\_do\_call ##
Call another winetricks verb, but don't abort if it fails.  You should usually use w\_call instead.

Example:
```
if ! w_do_call 7zip
then
   w_die "Sorry, I need 7zip to unpack this installer"
fi
```

## w\_download ##
Downloads a file to the cache and verifies its sha1sum.  Can also rename the file before saving.

The resulting file is saved in the directory "$W\_CACHE/$W\_PACKAGE".

It's important to give the sha1sum because that guards against bad downloads.

To figure out the right sha1sum to use, download it once yourself somehow, then run the linux command sha1sum on the downloaded file, and copy the resulting checksum into your script.

Usage: `w_download url [sha1sum [final_filename]]`

The square brackets above indicate optional arguments, i.e. you can give just url, or url and sha1sum, or all three.

Example:
```
w_download http://downloads.popcap.com/www/popcap_downloads/PlantsVsZombiesSetup.exe c46979be135ef1c486144fa062466cdc51b740f5
```

## w\_download\_manual ##
Usage: w\_download\_manual url filename sha1sum

Used when the file to be downloaded doesn't have a direct URL, and
the user has to do some clicking and typing to get at it.

If the file already exists and has a good checksum, this function
does nothing.

If the file does not exist, this function opens the user's web browser
to the download page for a file,
opens the user's explorer to the directory it should be downloaded to,
then quits after prompting the user to do a manual download of the file
and rerun winetricks once it is ready.

Example:
```
w_download_manual http://download.cnet.com/Rise-of-Nations-Trial-Version/3000-7562_4-10730812.html RiseOfNationsTrial.exe 33cbf1ebc0a93cb840f6296d8b529f6155db95ee
```

## w\_download\_torrent ##

Used when the file has to be downloaded via bittorrent, and the
torrent file has already been downloaded.

Example:
```
w_download http://www.hellokittyonline.com/images/downloads/hkostandardinstaller.torrent fcbb6869551ba251a08402f6de81855e829407e9
if ! test -f "$W_CACHE/hko/Hello Kitty Online Standard Installer.zip"
then
    w_download_torrent hkostandardinstaller.torrent
fi
```

## w\_metadata ##

Announces a verb to the menu system.  Used before defining each load\_XXX function.

Usage:
```
w_metadata verbname category key1="value1" \
  key2="value2" \
  ...
```

Required keys for games and apps are title, publisher, year, media, file1, and installed\_file1 (or installed\_exe1).

Example:
```
w_metadata hko games \
    title="Hello Kitty Online" \
    publisher="Sanrio Digital" \
    year="2009" \
    media="download" \
    file1="Hello Kitty Online Standard Installer.zip" \
    installed_exe1="$W_PROGRAMS_X86_WIN/SanrioTown/Hello Kitty Online/HKO.exe"
```

file1 is the name of either the downloaded installer, or the volume name of the disc followed by .iso.  If you get this wrong, the command "winetricks list-cached" won't be able to list this verb.

installed\_file1 (or installed\_exe1) is the Windows path to an installed file (or executable), but with slashes rather than backslashes.  (Note: This may change to a Unix path in the future.)
If you get this wrong, the command "winetricks list-installed" won't be able to list this verb... or might list it when it shouldn't.

## w\_mount ##
## w\_override\_all\_dlls ##
## w\_override\_app\_dlls ##
## w\_override\_dlls ##
## w\_override\_no\_dlls ##
## w\_pathconv ##
## w\_read\_key ##
## w\_register\_font ##
## w\_register\_font\_substitution ##
## w\_set\_app\_winver ##
## w\_set\_winver ##
## w\_skip\_windows ##
## w\_try ##
## w\_try\_cabextract ##
## w\_try\_regedit ##
## w\_try\_regsvr ##
## w\_try\_unzip ##
## w\_umount ##
## w\_unset\_winver ##
## w\_verify\_sha1sum ##
## w\_warn ##
## w\_workaround\_wine\_bug ##