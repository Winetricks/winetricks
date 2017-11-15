# Contributing to Winetricks

## License:
Winetricks is licensed under the LGPL 2.1 or later. Sending a pull request indicates your willingness to license your contribution under this license.

## Coding standards:
* Documented at top of ```src/winetricks```
* POSIX shell, no bash (maintainer's scripts can be python/bash)
* If something is unclear, ask

## Making a patch:
* Check out the source: ```git clone git@github.com:Winetricks/winetricks.git```
* Hack the source: ```vi src/winetricks```
* Test it:
    * Ideally, Winetricks should work under any Wine version. In practice, testing against the current development and stable versions is sufficient.
        * If a bug is only present in some Wine versions, w_workaround_bug() should be used
    * ```./src/winetricks -q -v foo```
    * ```./tests/shell-checks```: MUST pass (Travis CI verifies)
        * This tool uses checkbashisms (package `devscripts` on Debian-based distributions) and [ShellCheck](https://github.com/koalaman/shellcheck)
        * If ShellCheck fails, see [ShellCheck wiki](https://github.com/koalaman/shellcheck/wiki) and fix/[ignore](https://github.com/koalaman/shellcheck/wiki/Ignore) the error(s)
            * Detailed error information is available in the wiki (e.g. [SC2154](https://github.com/koalaman/shellcheck/wiki/SC2154))
    * ```./tests/winetricks-test check```: optional but recommended, if you have the time and hard drive space this should be run

## Sending your patch:
* Commit:
    * Commit should start with component affected, or misc/winetricks if generic, followed by a short summary:
    ```git commit -a -m 'vcrun2005: fix a typo'```
        * If you add a new verb, use the format: `verb_name: new verb(, description...)`
    * Extended git logs are okay if more explanation is needed
* Send PR: https://github.com/Winetricks/winetricks/compare/
* If you are asked for changes:
    * Edit the source/commit as appropriate: ```vi src/winetricks``` / ```git commit --amend -a```
    * Force push ```git push -f your_org your_repo```
    * Github will automatically update the Pull Request, but it WON'T send a notification.
    * Make sure to comment/tag maintainer so he knows there's been an update

## Bug reports:
* Bug reports must contain, at a minimum:
    * The Winetricks version (printed at top of stdout, or use ```winetricks --version```)
    * The Wine version used (```wine --version```)
    * The failing command (```winetricks foobar```)
    * The terminal output, preferably as a ```.txt``` attachment
    * Bug reports lacking this information may be closed without warning

* Feature requests should provide as much detail as possible, along with the tested Winetricks version
