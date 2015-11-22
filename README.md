# winetricks
Homepage of Winetricks, previously hosted at https://code.google.com/p/winetricks

Winetricks is an easy way to work around problems in Wine.

It has a menu of supported games/apps for which it can do all the workarounds automatically. It also lets you install missing DLLs or tweak various Wine settings individually.

The latest version can be downloaded here:
https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

Tagged releases are accessible here:
https://github.com/Winetricks/winetricks/releases

# Tests
Makefile supports two tests targets, check and test.
Make check will run tests/winetricks-test.
While make test will first delete winetricks' cache before running tests/winetricks-test, to ensure that the downloads are still valid.
