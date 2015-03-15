## Environment Variables Read by Winetricks ##

On startup, Winetricks checks the value of several environment
variables:

  * WINE - which wine binary to use (default: wine)
  * WINEPREFIX - path to default wineprefix (default: $HOME/.wine)
  * XDG\_CACHE\_HOME - path to system's user data cache (default: $HOME/.cache)
  * W\_CACHE - path to Winetrick's user data cache (default: $XDG\_CACHE\_HOME/winetricks}
  * LANG - used when outputting localized messages.

(Todo: complete this list)

## Predefined Variables ##
Verbs can rely on the following variables being set before they are executed:

  * WINE - use this if you need to run wine
  * WINEPREFIX - set to current wineprefix (not always the default one)
  * W\_APPDATA\_UNIX - Unix path to user's Application Data folder
  * W\_APPDATA\_WIN - Windows path to user's Application Data folder
  * W\_CACHE - a Unix path to the directory where downloaded files are cached.
  * W\_CACHE\_WIN - a Windows path version of W\_CACHE
  * W\_DRIVE\_C - a Unix path to the C:\ directory
  * W\_ISO\_MOUNT\_ROOT - the Unix path to where the install disc is mounted
  * W\_ISO\_MOUNT\_LETTER - the drive letter the install disc is mounted on
  * W\_KEY - the key for this package (set by w\_read\_key)
  * W\_OPT\_UNATTENDED - if 1, install app without asking any questions
  * W\_PACKAGE - the code for the currently executing recipe.  e.g. this is set to bioshock\_demo before calling load\_bioshock\_demo.
  * W\_PROGRAMS\_DRIVE - drive letter the standard Program Files directory is on
  * W\_PROGRAMS\_UNIX - Unix path to standard Programs Files directory
  * W\_PROGRAMS\_WIN - Windows path to standard Programs Files directory
  * W\_PROGRAMS\_X86\_UNIX - Unix path to standard 32 bit Programs Files directory
  * W\_PROGRAMS\_X86\_WIN - Windows path to standard 32 bit Programs Files directory
  * W\_TMP - a Unix path to a directory which exists and is empty when the function starts, and is deleted when the function exits.  This is where to unpack .zip files, etc.
  * W\_TMP\_WIN - same as W\_TMP, but as a Windows path

(TODO: correct and complete this list)