Most people won't need this.

If for some reason you're doing repeated installs of
the same title (e.g. if you're doing a regression test),
you can have Winetricks use a postinstall script to automatically
execute a few commands after a game is installed.

Postinstall scripts live in the directory
$WINETRICKS\_POST, which defaults to $HOME/.local/share/winetricks/postinstall.

After winetricks installs title xyz, it sources the file named
$WINETRICKS\_POST/xyz/xyz-postinstall.sh (if it exists).

That script can refer to winetricks [Variables](Variables.md) and [Functions](Functions.md)
like $WINETRICKS\_POST, $W\_PROGRAMS\_X86\_UNIX, w\_ahk\_do, etc.

Example: in Zoo Tycoon 2, you might want to have the postinstall
script transcode the .wma files into .mp3 so the game can play
them without having to install Windows Media.