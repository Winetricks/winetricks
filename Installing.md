If your linux distro ships an up-to-date winetricks, it's always best to use distro packages.  But when that fails, read on:

To download winetricks from http://winetricks.org/winetricks and
install it into /usr/bin:

```
rm -f winetricks
wget http://winetricks.org/winetricks
sudo cp winetricks /usr/bin
sudo chmod +x /usr/bin/winetricks
```

If you need a very recent change that isn't released yet, use http://winetricks.googlecode.com/svn/trunk/src/winetricks instead of http://winetricks.org/winetricks

See also
[a video showing how to do this on Ubuntu](http://www.youtube.com/watch?v=YYmbzYt8deo), and Dan's [Scale 9X presentation](http://kegel.com/wine/scale9x/scale9x-kegel-wine.pdf) for an introduction to Wine and Winetricks.  (See also FeaturedGames for videos about how to install games with Winetricks.)