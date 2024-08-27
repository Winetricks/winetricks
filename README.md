# Winetricks
[![License](https://img.shields.io/:license-lgpl-green.svg)](https://tldrlegal.com/license/gnu-lesser-general-public-license-v2.1-(lgpl-2.1))

Homepage of Winetricks, previously hosted at <https://code.google.com/p/winetricks>.

Winetricks is an easy way to work around problems in Wine.

It has a menu of supported games/apps for which it can do all the workarounds automatically. It also allows the installation of missing DLLs and tweaking of various Wine settings.

The latest version can be downloaded here:
https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

Tagged releases are accessible here:
https://github.com/Winetricks/winetricks/releases

# Installing
The ```winetricks``` package should be used if it is available and up to date. The package is available in most mainstream (Unix-like) Operating Systems:

* Arch: https://www.archlinux.org/packages/multilib/x86_64/winetricks/
* Debian: https://packages.debian.org/search?searchon=names&keywords=winetricks
* Fedora: https://fedoraproject.org/wiki/Wine#Packages
* FreeBSD: https://www.freebsd.org/cgi/ports.cgi?query=winetricks&stype=all
* Gentoo: https://packages.gentoo.org/packages/app-emulation/winetricks
* Homebrew (OSX): https://formulae.brew.sh/formula/winetricks
* MacPorts (OSX): https://www.macports.org/ports.php?by=name&substr=winetricks
* Slackbuilds (Slackware): https://slackbuilds.org/apps/winetricks/
* Ubuntu: https://packages.ubuntu.com/search?keywords=winetricks

Note: packaged Debian / Ubuntu winetricks versions are typically outdated, so a manual installation is recommended.

## Manual Install

If the package is unavailable, outdated, or the latest version is desired, a manual installation of winetricks can be done.
It is _highly_ recommended to uninstall any previously installed version of winetricks first.

**_If you don't uninstall a previously installed, packaged version of winetricks... Well then you get to pick up the pieces!_**

E.g. for Debian / Ubuntu:
```
sudo apt-get purge winetricks
```

### Installing The Latest Stable Release

Download the latest release from [Github](https://github.com/Winetricks/winetricks/releases/latest).

Extract the archive and `cd` into the extracted folder.

Run `sudo make install` to install Winetricks system-wide.

### Scripted Install

You can use a shell script to download the current winetricks script(s):

```
#!/bin/sh
# Create and switch to a temporary directory writeable by current user. See:
#   https://www.tldp.org/LDP/abs/html/subshells.html
cd "$(mktemp -d)" || exit 1

# Use a BASH "here document" to create an updater shell script file.
# See:
#   https://www.tldp.org/LDP/abs/html/here-docs.html
# >  outputs stdout to a file, overwriting any pre-existing file
# << takes input, directly from the script itself, till the second '_EOF_SCRIPT' marker, as stdin
# the cat command hooks these 2 streams up (stdin and stdout)
###### create update_winetricks START ########
cat > update_winetricks <<_EOF_SCRIPT
#!/bin/sh

# Create and switch to a temporary directory writeable by current user. See:
#   https://www.tldp.org/LDP/abs/html/subshells.html
cd "\$(mktemp -d)"

# Download the latest winetricks script (master="latest version") from Github.
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

# Mark the winetricks script (we've just downloaded) as executable. See:
#   https://www.tldp.org/LDP/GNU-Linux-Tools-Summary/html/x9543.htm
chmod +x winetricks

# Move the winetricks script to a location which will be in the standard user PATH. See:
#   https://www.tldp.org/LDP/abs/html/internalvariables.html
sudo mv winetricks /usr/bin

# Download the latest winetricks BASH completion script (master="latest version") from Github.
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion

# Move the winetricks BASH completion script to a standard location for BASH completion modules. See:
#   https://www.tldp.org/LDP/abs/html/tabexpansion.html
sudo mv winetricks.bash-completion /usr/share/bash-completion/completions/winetricks

# Download the latest winetricks MAN page (master="latest version") from Github.
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.1

# Move the winetricks MAN page to a standard location for MAN pages. See:
#   https://www.pathname.com/fhs/pub/fhs-2.3.html#USRSHAREMANMANUALPAGES
sudo mv winetricks.1 /usr/share/man/man1/winetricks.1
_EOF_SCRIPT
###### create update_winetricks FINISH ########

# Mark the update_winetricks script (we've just written out) as executable. See:
#   https://www.tldp.org/LDP/GNU-Linux-Tools-Summary/html/x9543.htm
chmod +x update_winetricks

# We must escalate privileges to root, as regular Linux users do not have write access to '/usr/bin'.
sudo mv update_winetricks /usr/bin/
```

See the manpages for the individual functions, if you are not clear how they are being used, e.g.
```
man mktemp
man mv
man wget
man sudo
...
```

An alternative updater script implementation, using **su** in place of **sudo**, is also possible:

```
cd "$(mktemp -d)"
cat > update_winetricks <<_EOF_SCRIPT
#!/bin/sh

cd "\$(mktemp -d)"
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion
chmod +x winetricks
su root sh -c 'mv winetricks /usr/bin ; mv winetricks.bash-completion /usr/share/bash-completion/completions/winetricks'
_EOF_SCRIPT

chmod +x update_winetricks
su root sh -c 'mv update_winetricks /usr/bin/'
```

To use ```curl``` instead of ```wget```: substitute all ```wget``` calls with ```curl -O```, in the winetricks update script.

# Updating
Using the traditional Unix crontab...
```
sudo ln "/usr/bin/update_winetricks" "/etc/cron.weekly/update_winetricks"
```
Note: ensure you have a cron utility installed and enabled, on systems utilizing **systemd** by default.

The update script can be automated, to run on a set schedule, via (where available) **systemd** units.
E.g. to create a scheduled winetricks updater **systemd** **timer** unit, and an associated **systemd** **service** unit:
```
cd "$(mktemp -d)"
cat > winetricks_update.timer <<_EOF_TIMER_UNIT
[Unit]
Description=Run winetricks update script weekly (Saturday)

[Timer]
OnCalendar=Sat
Persistent=true

[Install]
WantedBy=timers.target
_EOF_TIMER_UNIT

cat > winetricks_update.service <<_EOF_SERVICE_UNIT
[Unit]
Description=Run winetricks update script
After=network.target

[Service]
ExecStart=/bin/sh /usr/bin/update_winetricks
Type=oneshot
_EOF_SERVICE_UNIT

sudo mv winetricks_update.timer winetricks_update.service /etc/systemd/system/
```
See:
* [freedesktop.org: systemd service unit](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
* [freedesktop.org: systemd timer unit](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)

To start and enable the winetricks update timer:
```
sudo systemctl daemon-reload
sudo systemctl enable winetricks_update.timer
sudo systemctl start winetricks_update.timer
```

The core winetricks script can also be updated by simply doing:
```
winetricks --self-update
```
or:
```
sudo winetricks --self-update
```
for a system-wide winetricks installation.

# Custom .verb files
New dll/settings/programs can be added to Winetricks by passing a custom .verb (format below)

Example `icecat.verb`:

```
w_metadata icecat apps \
    title="GNU Icecat 38.8.0" \
    publisher="GNU Foundation" \
    year="2016" \
    media="download" \
    file1="icecat-38.8.0.en-US.win32.zip" \
    installed_exe1="${W_PROGRAMS_X86_WIN}/icecat/icecat.exe"

load_icecat()
{
    w_download https://ftp.gnu.org/gnu/gnuzilla/38.8.0/${file1} e5f9481e78710c25eb3a271d81aceb19ef44ff6e8599da7d5f7a2da584c01213
    w_try_unzip "${W_PROGRAMS_X86_UNIX}" "${W_CACHE}/${W_PACKAGE}/icecat-38.8.0.en-us.win32.zip"
}
```

Note that the file prefix (icecat.verb) and command name (icecat) must match. All metadata fields are optional, only the command name and category are required.

# Tests
The tests need `bashate` and `shellcheck>=0.4.4` installed.
Makefile supports a few test targets:

* `check` - runs './tests/winetricks-tests quick' (without first clearing $WINETRICKS_CACHE)
* `shell-checks` - runs './tests/shell-checks'
* `test` - runs './tests/winetricks-tests full' (and clears $WINETRICKS_CACHE first)
* `xvfb-check` - runs './tests/winetricks-tests xvfb-check' (without first clearing $WINETRICKS_CACHE first)

# Support
* Winetricks is maintained by Austin English <austinenglish@gmail.com>.
* If winetricks has helped you out, then please consider donating to the FSF/EFF as a thank you:
  * EFF - https://supporters.eff.org/donate/button
  * FSF - https://my.fsf.org/donate
  * Donations towards electricity bill and developer beer fund can be sent via Bitcoin to 18euSAZztpZ9wcN6xZS3vtNnE1azf8niDk
* I try to actively respond to bugs and pull requests on GitHub:
  * Bugs: https://github.com/Winetricks/winetricks/issues/new
  * Pull Requests: https://github.com/Winetricks/winetricks/pulls
