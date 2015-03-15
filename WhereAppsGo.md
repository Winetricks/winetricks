## Menus ##

Every Windows game or app you install shows up in your system's normal menus under 'Applications -> Wine -> Programs', regardless of whether you install it with Wine by yourself, or using Winetricks.

Some apps also install desktop icons.

## Program Files ##

Winetricks installs each app into its own isolated fake windows environment, or _wineprefix_.  It does this to keep the workarounds
needed for the various apps from interfering with each other.  (Someday, wine won't need these workarounds, nor winetricks itself.)
All the wineprefixes live in the directory $HOME/.local/share/wineprefixes.
If you want apps to go into the default wineprefix, or the one specified
by WINEPREFIX, you need to give the --no-isolate option.

Libraries are installed into the default wineprefix, $HOME/.wine, by
default.  If you set WINEPREFIX, the libraries go there.

## Configuration Files ##

Apps usually save their configuration files live inside the wineprefix in subdirectories of $WINEPREFIX/drive\_c/users/$USERNAME.
This is usually just a symlink to your home directory.

If you want to isolate an app so that it doesn't save anything to
your home directory, you can try 'winetricks sandbox'.  That will
remove the symlinks to your home directory.  Do this before saving any
data, or you'll have to copy old saved data from your home directory
into $WINEPREFIX/drive\_c/users/$USERNAME.