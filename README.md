# Winetricks
Homepage of Winetricks, previously hosted at <https://code.google.com/p/winetricks>.

Winetricks is an easy way to work around problems in Wine.

It has a menu of supported games/apps for which it can do all the workarounds automatically. It also lets you install missing DLLs or tweak various Wine settings individually.

The latest version can be downloaded here:
https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

Tagged releases are accessible here:
https://github.com/Winetricks/winetricks/releases

# Custom .verb files
You can pass winetricks a custom .verb (format below), that can be used to add new dlls/settings/programs.

Example `icecat.verb`:
```
w_metadata icecat apps \
    title="GNU Icecat 31.7.0" \
    publisher="GNU Foundation" \
    year="2016" \
    media="download" \
    file1="icecat-31.7.0.en-US.win32.zip" \
    installed_exe1="$W_PROGRAMS_X86_WIN/icecat/icecat.exe"

load_iceweasel()
{
    w_download https://ftp.gnu.org/gnu/gnuzilla/38.8.0/icecat-38.8.0.en-US.win32.zip b9f49144f07044f12afc390acb36bf93e174e199
    w_try_unzip "${W_PROGRAMS_X86_UNIX}" "${W_CACHE}/${W_PACKAGE}/${file1}"
}
```
Note that the filename and command name (icecat) must match. All metadata fields are optional, only command name and category required.

# Tests
The tests need `checkbashisms` and `shellcheck>=0.4.4` installed.
Makefile supports a few test targets:
* check - runs './tests/winetricks-tests quick' (without first clearing $WINETRICKS_CACHE)
* shell-checks - runs './tests/shell-checks'
* test - runs './tests/winetricks-tests full' (and clears $WINETRICKS_CACHE first)
* xvfb-check - runs './tests/winetricks-tests xvfb-check' (without first clearing $WINETRICKS_CACHE first)

# Support
* Winetricks is maintained by Austin English <austinenglish!$gmail.com>.
* If winetricks has helped you out, then please consider donating to the FSF/EFF as a thank you:
  * EFF - https://supporters.eff.org/donate/button
  * FSF - https://my.fsf.org/donate
* Donations towards electricity bill and developer beer fund can be sent via Paypal to above address.
* I try to actively respond to bugs and pull requests on GitHub:
* Bugs: https://github.com/Winetricks/winetricks/issues/new
* Pull Requests: https://github.com/Winetricks/winetricks/pulls
