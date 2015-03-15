## How do I uninstall an application? ##

There are two ways.

The easiest and most reliable is to delete the
entire wineprefix the application was installed to.
In the GUI, select the wineprefix, then choose "Delete ALL DATA AND APPLICATIONS INSIDE THIS WINEPREFIX".
Or, from the commandline, do `winetricks prefix=$prefixname annihilate`.

You can also try running the app's uninstaller, though that is not as reliable.