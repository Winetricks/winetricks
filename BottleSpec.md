Winetricks obeys http://wiki.winehq.org/BottleSpec
as follows:

  * it creates wineprefixes in ~/.local/share/wineprefixes
  * when it creates a wineprefix, it creates the file wrapper.cfg containing the line `ww_name="Title of app"`
  * when it lists a wineprefix, it displays both the directory name and the value of ww\_title

Furthermore, whenever it modifies a wineprefix, it appends a line to the file winetricks.log in the wineprefix.  (That will probably change to wrapper.log once that becomes part of http://wiki.winehq.org/BottleSpec.)  This is intended to help users figure out what they did to a wineprefix.