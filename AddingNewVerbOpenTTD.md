See also AddingNewVerbs.

## OpenTTD ##

[OpenTTD](http://openttd.org) is a small transit simulator
that has a nice download page that already has sha1sums.
We'll use the win7 installer version in this example.

### Step 1 ###

First, start out by creating a text file named openttd.verb
containing a basic verb as described in AddingNewVerbs:

```
w_metadata openttd games \
    title="OpenTDD (inspired by Transit Tycoon Deluxe)" \
    publisher="openttd.org" \
    year="2011" \
    media="download" \
    file1="openttd-1.1.0-windows-win32.exe" 

load_openttd() 
{
    w_download http://binaries.openttd.org/releases/1.1.0/openttd-1.1.0-windows-win32.exe f6c42da8614577e022cb2f4496ff470a89f4c6c7
    cd "$W_CACHE/openttd"
    $WINE openttd-1.1.0-windows-win32.exe
}
```

Then test it by doing
```
winetricks openttd.verb
```

Hey, presto, it installs and runs!

### Step 2: fill in installed\_exe1 ###

Now see where the game got installed.
The easiest way to do this in a terminal is to
install the aliases described in CommandlineTips, then do
```
prefix openttd
goc
```
That takes you to the top of the virtual C drive for the new game.
You can then use bash's tab completion to avoid having to type
out Program Files in full, e.g.
```
cd Pro<TAB>/Open<TAB>
ls
```
And there you see openttd.exe.  Now you know where the game's executable
lives, and can fill in the installed\_exe1 line at the end of the metadata:

```
w_metadata openttd games \
    title="OpenTDD (inspired by Transit Tycoon Deluxe)" \
    publisher="openttd.org" \
    year="2011" \
    media="download" \
    file1="openttd-1.1.0-windows-win32.exe" \
    installed_exe1="$W_PROGRAMS_X86_WIN/OpenTTD/openttd.exe"
```

Now test to make sure the install check works:

```
winetricks openttd.verb list-installed
```

openttd should show up in the list of installed games.

### Step 3: make -q work ###

(This step is optional, but it helps the winetricks maintainer
verify he hasn't broken your verb later.)

See also AddingNewVerbs#Unattended\_Mode

First, check to see if the game's installer has an unattended (or silent) install option.
You can often tell by doing
```
cd ~/.cache/winetricks/openttd
strings openttd-1.1.0-windows-win32.exe | less
```
There is lots of crap to wade through... after pressing page down
14 times, I saw
```
http://nsis.sf.net/NSIS_Error
```
Aha!  According to http://unattended.sourceforge.net/installers.php,
NSIS installers will usually do a silent install if you give the
/S (must be uppercase) option.  Trying this out interactively with
```
wine openttd-1.1.0-windows-win32.exe /s
```
verifies that it really works, and installs the game without putting up
a window.  So all we need to do to support silent mode is change
our script to add /S when $W\_OPT\_UNATTENDED is nonempty, e.g.
by using the fancy ${W\_OPT\_UNATTENDED:+ /S} syntax:
```
load_openttd() 
{
    w_download http://binaries.openttd.org/releases/1.1.0/openttd-1.1.0-windows-win32.exe f6c42da8614577e022cb2f4496ff470a89f4c6c7
    cd "$W_CACHE/openttd"
    $WINE openttd-1.1.0-windows-win32.exe ${W_OPT_UNATTENDED:+ /S}
}
```