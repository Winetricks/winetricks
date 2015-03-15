## AutoHotkey ##
If you need to send keystrokes or mouse clicks to a Windows
app (e.g. an installer), [AutoHotkey](http://www.autohotkey.com) is usually the tool for the job.

It has quite a bit of [documentation](http://www.autohotkey.com/docs/),
and a [quick-start tutorial](http://www.autohotkey.com/docs/Tutorial.htm).
The most useful documentation is its [command reference](http://www.autohotkey.com/docs/commands.htm).

## AutoHotkey for Winetricks contributors ##

Winetricks takes care of installing and starting autohotkey for
you; all you have to do is call w\_ahk\_do with the desired autohotkey commands.

## Hello, Autohotkey ##

Let's try the canonical autohotkey example: starting Notepad and
typing some text.  To do this, create a text file named hello.verb
containing the lines

<pre>
w_metadata hello apps \<br>
title="Hello, Autohotkey"<br>
<br>
load_hello()<br>
{<br>
w_ahk_do "<br>
[http://www.autohotkey.com/docs/commands/Run.htm run] notepad.exe               ; Comments start with semicolons<br>
[http://www.autohotkey.com/docs/commands/WinWait.htm winwait] Untitled - Notepad    ; Wait for a window with this exact title to appear<br>
[http://www.autohotkey.com/docs/commands/Send.htm send] hello, autohotkey        ; Act as if the user typed those words at the keyboard<br>
"<br>
}<br>
</pre>

Then try running it with
```
winetricks hello.verb
```

You should see Notepad appear, and "Hello, autohotkey" appear in its
document window.

## A Real Example: Age of Empires Demo ##

### Part One: the basic verb ###

Here's a simple verb that doesn't (yet) support winetricks' -q option
for silent installation.  Create a file aoe\_example.verb containing:

<pre>
w_metadata aoe_example games \<br>
title="Age of Empires Demo" \<br>
publisher="Microsoft" \<br>
year="1997" \<br>
media="download" \<br>
file1="MSAoE.exe" \<br>
installed_exe1="$W_PROGRAMS_X86_WIN/Microsoft Games/Age of Empires Trial/empires.exe"<br>
<br>
load_aoe_example()<br>
{<br>
w_download http://download.microsoft.com/download/aoe/Trial/1.0/WIN98/EN-US/MSAoE.exe<br>
<br>
cd "$W_CACHE/$W_PACKAGE"<br>
w_try $WINE MSAoE.exe<br>
}<br>
</pre>

It's a good verb.  You can run it by doing 'winetricks aoe\_example.verb', and it runs the installer faithfully.

### Part Two: supporting unattended mode ###

If you want your verb to obey winetricks' -q (or unattended install) option, though, you'll have to do a bit more.

The goal of unattended mode is to not ask the user any questions.
(It's good to show progress bars during long operations even in
unattended mode, so don't suppress those if you can help it.)

First, check to see if the installer supports a commandline option
for unattended or silent install (e.g. /S).  If it does, use that instead of autohotkey; see AddingNewVerbOpenTTD for an example.
(And the first two games I looked at when writing this tutorial
turned out to support exactly that option!)

If you've looked and looked, and there's no way to script an unattended
install from the commandline, you can use autohotkey to script
the installer's GUI.

The basic motif of scripting an install with autohotkey is to
wait for a window with a particular name (and maybe particular body text) to show up, answer its question (if any) by clicking a button, and
then click the 'next' button.

For example, to get past the welcome dialog of an installer, you might do
```
winWait, Microsoft Age of Empires
ControlClick, Button1    ; Next
```

To figure out what commands are needed, start by changing your
function so autohotkey just runs the installer and then waits forever.
Here's an example including standard boilerplate options, e.g.

<pre>
load_aoe_example()<br>
{<br>
w_download http://download.microsoft.com/download/aoe/Trial/1.0/WIN98/EN-US/MSAoE.exe<br>
<br>
cd "$W_CACHE/$W_PACKAGE"<br>
w_ahk_do "<br>
[http://www.autohotkey.com/docs/commands/SetWinDelay.htm SetWinDelay] 1000        ; wait extra second after each winwait<br>
[http://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm SetTitleMatchMode], 2    ; allow matching substrings<br>
[http://www.autohotkey.com/docs/commands/Run.htm run] MSAoE.exe<br>
[http://www.autohotkey.com/docs/commands/WinWait.htm winwait] nosuchwindow    ; We will change this later<br>
"<br>
}<br>
</pre>

[SetWinDelay](http://www.autohotkey.com/docs/commands/SetWinDelay.htm) is needed because installers often aren't ready for keystrokes or mouse clicks right after a window appears.

[SetTitleMatchMode, 2](http://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm) means future winwait statements should match
windows given only a fragment of their full title.

Run that as before by doing 'winetricks aoe\_example.verb'.
Note that an 'H' icon shows up in the system tray; this is autohotkey's status icon.
Right-click on that 'H' icon and select "Window Spy",
then click on the installer window's title bar.
This will bring up a little window that tells you interesting stuff
about the active window and whatever the mouse is pointing at in that window.

Go ahead and install as normal, but before you answer the installer's questions,
fire up your editor, put the cursor in between the run and winwait
lins in your function, and start writing the autohotkey commands
for what you do as you do it.  A few examples:
  * Do you have to press the Enter key?  Then write `send {Enter} `.
  * Do you have to click a button?  Then use the Spy utility you started above to find out the button's name, and write `ControlClick, buttonName`.  Alternately, figure out what key to send, and use `send` to send it.
  * After you click 'Next', be sure to wait for the change to take effect, e.g. by writing `WinWait, windowname, unique text in window`.  Otherwise your next click might be sent before the installer is ready!
  * Be sure to wait for the last window to close by writing `WinWaitClose`.

You should end up with something like this:

<pre>
load_aoe_demo()<br>
{<br>
w_download http://download.microsoft.com/download/aoe/Trial/1.0/WIN98/EN-US/MSAoE.exe<br>
<br>
cd "$W_CACHE/$W_PACKAGE"<br>
w_ahk_do "<br>
SetWinDelay 1000<br>
SetTitleMatchMode, 2<br>
run, MSAoE.exe<br>
winwait, Microsoft Age of Empires<br>
ControlClick, Button1<br>
winwait, End User License<br>
ControlClick, Button1<br>
winwait, Microsoft Age of Empires, Setup will install<br>
ControlClick Button2<br>
winwait, Microsoft Age of Empires, Setup has successfully<br>
ControlClick Button1<br>
WinWaitClose<br>
<br>
"<br>
}<br>
</pre>

But that **always** installs automatically.  Better make it not
press any keys for you unless -q is given.  Here's how:


<pre>
load_aoe_demo()<br>
{<br>
w_download http://download.microsoft.com/download/aoe/Trial/1.0/WIN98/EN-US/MSAoE.exe<br>
<br>
cd "$W_CACHE/$W_PACKAGE"<br>
w_ahk_do "<br>
SetWinDelay 1000<br>
SetTitleMatchMode, 2<br>
run, MSAoE.exe<br>
winwait, Microsoft Age of Empires<br>
if ( w_opt_unattended > 0 ) {<br>
ControlClick, Button1<br>
winwait, End User License<br>
ControlClick, Button1<br>
winwait, Microsoft Age of Empires, Setup will install<br>
ControlClick Button2<br>
winwait, Microsoft Age of Empires, Setup has successfully<br>
ControlClick Button1<br>
}<br>
WinWaitClose<br>
<br>
"<br>
}<br>
</pre>

Finally, test your verb again with 'sh winetricks -q aoe\_example' (shouldn't require any user intervention), and
and 'sh winetricks aoe\_example' (should require user to answer all
questions).

## Troubleshooting ##

### Help!  The installer is ignoring something I'm sending it! ###

The most common cause of this is the previous WinWait being too general, and returning before the previous input takes effect.  Each WinWait should wait for some unique text; since titles usually don't change, that means you need to do `WinWait, windowtitle, unique text from body of new screen`.




## Advanced Techniques ##

### Optional Dialogs ###

Some installers have dialogs that only show up under certain
conditions.  The general technique for handling these is to
have a loop which waits for either the optional dialog(s), and
handles them.  The loop continues until it sees the dialog after
the optional ones, at which point it exits and flow returns to normal.
For examples, here's how the verb for crysis2 does it:
```
            Loop {
                ; On Windows, this window does not pop up
                ifWinExist, Microsoft Visual C++ 2008 Redistributable Setup
                {
                    winwait, Microsoft Visual C++ 2008 Redistributable Setup
                    controlclick, Button12 ; Next
                    winwait, Visual C++, License
                    controlclick, Button11 ; Agree
                    controlclick, Button8  ; Install
                    winwait, Setup, configuring
                    winwaitclose
                    winwait, Visual C++, Complete
                    controlclick, Button2  ; Finish
                    break
                }
                ifWinExist, Setup, Please read the End User
                {
                    break
                }
                sleep 1000   ; sleep a sec to avoid burning cpu
            }
            winwait, Setup, Please read the End User
            ...
```

To find more examples, search for Loop in winetricks.