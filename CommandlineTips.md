When Wine installs menu items for an app, they automatically point
to the right wineprefix, which is great.  But if you're a commandline
user, what you really want is a convenient way to access those
wineprefixes from the commandline.  Here's one way: add these three
shell functions to your ~/.bashrc:

```

prefix() {
   export WINEPREFIX="$HOME/.local/share/wineprefixes/$1"
}

goc() {
   cd $WINEPREFIX/drive_c
}

lsp() {
   ls $* $HOME/.local/share/wineprefixes
}

```

Those let you select or go to any wineprefix, or list them all.

You might also find this one handy; it relies on the fact that most
winetricks verbs that install apps also install batch files to start
those apps:

```

run() {
   prefix $1
   goc
   wine cmd /c run-$1.bat
}

```

although there's probably a better way to do that.