# Winetricks
Homepage of Winetricks, previously hosted at <https://code.google.com/p/winetricks>.

Winetricks is an easy way to work around problems in Wine.

It has a menu of supported games/apps for which it can do all the workarounds automatically. It also allows the installation of missing DLLs and tweaking of various Wine settings.

The latest version can be downloaded here:
https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

Tagged releases are accessible here:
https://github.com/Winetricks/winetricks/releases

# Installing
The ```winetricks``` package should be used if it is available and up to date. The package is available in most distributions:

* Arch: https://www.archlinux.org/packages/community/any/winetricks/
* Debian: https://packages.debian.org/sid/winetricks
* Fedora: https://fedoraproject.org/wiki/Wine#Packages
* Gentoo: https://packages.gentoo.org/packages/app-emulation/winetricks
* Homebrew (OSX): http://brewformulas.org/Winetricks
* MacPorts (OSX): https://www.macports.org/ports.php?by=name&substr=winetricks
* Slackbuilds (Slackware): http://slackbuilds.org/repository/14.2/system/winetricks/?search=winetricks
* Ubuntu: https://packages.ubuntu.com/search?keywords=winetricks Note: Ubuntu LTS versions are years out of date, a manual installation should be done instead.

If the package is unavailable, outdated (e.g., Ubuntu LTSs), or the latest version is desired, a manual installation of winetricks can be done:
```
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo mv winetricks /usr/local/bin
```
curl can be used instead of wget:

```
curl -O https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo mv winetricks /usr/local/bin
```
Note: /usr/local/bin must be in your $PATH for this to work.

Winetricks can be updated by doing:
```
winetricks --self-update
```

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
