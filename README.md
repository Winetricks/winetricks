# Winetricks
[![Build Status](https://travis-ci.org/Winetricks/winetricks.svg?branch=master)](https://travis-ci.org/Winetricks/winetricks) [![License](http://img.shields.io/:license-lgpl-green.svg)](https://tldrlegal.com/license/gnu-lesser-general-public-license-v2.1-(lgpl-2.1))

Homepage of Winetricks, previously hosted at <https://code.google.com/p/winetricks>.

Winetricks is an easy way to work around problems in Wine.

It has a menu of supported games/apps for which it can do all the workarounds automatically. It also allows the installation of missing DLLs and tweaking of various Wine settings.

The latest version can be downloaded here:
https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

Tagged releases are accessible here:
https://github.com/Winetricks/winetricks/releases

# Installing
The ```winetricks``` package should be used if it is available and up to date. The package is available in most mainstream (Unix-like) Operating Systems:

* Arch: https://www.archlinux.org/packages/community/any/winetricks/
* Debian: https://packages.debian.org/sid/winetricks
* Fedora: https://fedoraproject.org/wiki/Wine#Packages
* FreeBSD: https://www.freebsd.org/cgi/ports.cgi?query=winetricks&stype=all
* Gentoo: https://packages.gentoo.org/packages/app-emulation/winetricks
* Homebrew (OSX): http://brewformulas.org/Winetricks
* MacPorts (OSX): https://www.macports.org/ports.php?by=name&substr=winetricks
* Slackbuilds (Slackware): http://slackbuilds.org/repository/14.2/system/winetricks/?search=winetricks
* Ubuntu: https://packages.ubuntu.com/search?keywords=winetricks

Note: packaged Debian / Ubuntu winetricks versions are typically outdated, so a manual installation is recommended.

If the package is unavailable, outdated, or the latest version is desired, a manual installation of winetricks can be done. E.g.:

```
sudo -- sh -c '
cat > /usr/local/bin/update_winetricks.sh <<_EOF_SCRIPT
#!/bin/sh

cd "${HOME}" # change to a path writeable by current user
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo mv winetricks /usr/local/bin
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion
sudo mv winetricks.bash-completion /usr/share/bash-completion/completions/winetricks
_EOF_SCRIPT
chmod +x /usr/local/bin/update_winetricks.sh
'

```

To use ```curl``` instead of ```wget```: subsitute all ```wget``` calls with ```curl -O```, in the winetricks update script.

Note: the path ```/usr/local/bin``` must be in your ```PATH``` (env variable) for this to work.

# Updating
This winetricks update scripts can easily automated, via (where available) a systemd timer unit...
```
sudo -- sh -c '
cat > /etc/systemd/system/winetricks_update.timer <<_EOF_TIMER
[Unit]
Description=Run winetricks update script weekly (Saturday)

[Timer]
OnCalendar=Sat
Persistent=true

[Install]
WantedBy=timers.target
_EOF_TIMER

sudo cat > /etc/systemd/system/winetricks_update.service <<_EOF_SERVICE
[Unit]
Description=Run winetricks update script
After=network.target

[Service]
ExecStart=/usr/local/bin/update_winetricks.sh
Type=oneshot
_EOF_SERVICE
'
```
To start and enable the winetricks update timer:
```
sudo systemctl daemon-reload
sudo systemctl enable winetricks_update.timer
sudo systemctl start winetricks_update.timer
```
Or using the more tradional Unix crontab...
```
sudo cp "/usr/local/bin/update_winetricks.sh" "/etc/cron.weekly/"
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
    w_try_unzip "${W_PROGRAMS_X86_UNIX}" "${W_CACHE}/${W_PACKAGE}/${file1}"
}
```

Note that the file prefix (icecat.verb) and command name (icecat) must match. All metadata fields are optional, only the command name and category are required.

# Tests
The tests need `bashate`, `checkbashisms`, and `shellcheck>=0.4.4` installed.
Makefile supports a few test targets:

* check - runs './tests/winetricks-tests quick' (without first clearing $WINETRICKS_CACHE)
* shell-checks - runs './tests/shell-checks'
* test - runs './tests/winetricks-tests full' (and clears $WINETRICKS_CACHE first)
* xvfb-check - runs './tests/winetricks-tests xvfb-check' (without first clearing $WINETRICKS_CACHE first)

# Support
* Winetricks is maintained by Austin English <austinenglish@gmail.com>.
* If winetricks has helped you out, then please consider donating to the FSF/EFF as a thank you:
  * EFF - https://supporters.eff.org/donate/button
  * FSF - https://my.fsf.org/donate
  * Donations towards electricity bill and developer beer fund can be sent via Bitcoin to 18euSAZztpZ9wcN6xZS3vtNnE1azf8niDk
* I try to actively respond to bugs and pull requests on GitHub:
  * Bugs: https://github.com/Winetricks/winetricks/issues/new
  * Pull Requests: https://github.com/Winetricks/winetricks/pulls
