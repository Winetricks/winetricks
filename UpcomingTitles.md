Know a popular/good/recent/upcoming game we should support in winetricks?
Add it here.

Here are a few places to look for games that work on wine:
  * http://kegel.com/wine/games-2010.html
  * http://www.aplu.fr/polistats/stats_2011.html#list_get_num
  * http://www.steamgamesonlinux.com/
  * http://steamlinux.flibitijibibo.com/index.php?title=Wine_Platinum/Gold_Games
  * http://portingteam.com/
  * [appdb](http://appdb.winehq.org/objectManager.php?bIsQueue=false&bIsRejected=false&sClass=application&sTitle=Browse+Applications&iItemsPerPage=25&iPage=1&sOrderBy=appName&bAscending=true) (search for 'gold or higher')
  * Any popular Windows game that uses OpenGL, since games that don't have to translate directx to opengl are likely to achieve good frame rate

Here are a few places to look for upcoming or highly ranked games:
  * http://pc.gamespy.com/index/release.html
  * http://www.gamespot.com/games.html?type=top_rated&platform=5
  * http://www.gamerankings.com/pc/index.html
  * http://pc.gamezone.com/products/new_releases/

A few dozen verbs still need to be ported from [wisotool](http://winezeug.googlecode.com/svn/trunk/attic/wisotool) into winetricks.  (This is pretty easy, just need to update any w\_mount calls and add the W\_OPT\_UNATTENDED test in any autohotkey scripts, and retest.)

## Upcoming Games / Demos ##

These are not released yet, but we'd like to add support for them as soon as they come out (assuming they work in wine).

Brink (May 2011)
http://en.wikipedia.org/wiki/Brink_(video_game)

Heroes of Might and Magic 6 (Beta in June 2011)
http://might-and-magic.ubi.com/heroes-6/en-GB/home/

Deus Ex: Human Revolution (August 2011)
http://www.deusex.com/

Guild Wars 2 (11 November 2011)
http://www.guildwars2.com/

## Games Released in 2011 ##

World of Tanks (12 April 2011)
http://appdb.winehq.org/objectManager.php?sClass=version&iId=22521
http://forum.worldoftanks.com/index.php?/topic/7289-wot-under-linux/
http://www.gamerankings.com/pc/989519-world-of-tanks/index.html
http://en.wikipedia.org/wiki/World_of_Tanks

Portal 2 (18 April 2011)
http://en.wikipedia.org/wiki/Portal_2

Bulletstorm (22 Feb 2011)
Requires Windows Live even for singleplayer?  :-(

Everquest II: Destiny of Velious (Mar 2011)

Magicka (Scott already on this) (Jan 2011, 75%)
http://www.gamerankings.com/pc/988764-magicka/index.html

## Games Released in 2010 ##

Deathspank (2010, Steam) (no demo?)
http://store.steampowered.com/app/18040/
http://appdb.winehq.org/objectManager.php?sClass=version&iId=21793

Dead Rising 2 (2010) (no demo?)
Was one of the top 5 games of the year on Zero Punctuation:
http://www.escapistmagazine.com/videos/view/zero-punctuation/2607-Top-5-of-2010
but said to be sluggish
http://appdb.winehq.org/objectManager.php?sClass=version&iId=21516

Football Manager 2011 demo (Nov 2010, 87%)
http://www.bigdownload.com/games/football-manager-2011/pc/football-manager-2011-vanilla-demo/
http://www.gamerankings.com/pc/604983-football-manager-2011/index.html
(The 2010 version fails randomly, http://bugs.winehq.org/show_bug.cgi?id=23995 )

Land of Chaos Online (Aug 2010, 80%)
http://pc.ign.com/articles/110/1109105p1.html
http://www.massively.com/2010/03/11/gdc10-land-of-chaos-online-interview/
http://www.gamerankings.com/pc/977633-land-of-chaos-online/index.html

Lego Universe (Oct 2010, 72%)
http://universe.lego.com/
http://www.gamerankings.com/pc/939942-lego-universe/index.html

Mafia II Demo (Steam) (Aug 2010, 76%)
http://appdb.winehq.org/objectManager.php?sClass=version&iId=21257
(There's also http://www.bigdownload.com/games/mafia-ii/pc/mafia-2-demo/ but that installs steam.)
http://www.gamerankings.com/pc/942953-mafia-ii/index.html

Shogun II: Total War (demo 23 Feb 2010) (Steam)
http://store.steampowered.com/app/34330/

## Games released in 2009 ##

Far Cry 2 (2009)
http://appdb.winehq.org/objectManager.php?sClass=application&iId=8522

## Older Games ##

Good Old Games
http://www.gog.com/en/forum/general/gog_games_that_are_working_fine_with_linux_wine
has a list of the ones that work.  We removed GOG support when they shut down
recently (see http://code.google.com/p/winezeug/source/detail?r=1600 ), but now that they're back, we should revert [r1600](https://code.google.com/p/winetricks/source/detail?r=1600) and update it to work with the new GOG.com.

## Already done by someone (though not committed yet - FIXME) ##

Call of Duty 5: World at War
http://appdb.winehq.org/objectManager.php?sClass=version&iId=14475

Draftsight
http://www.3ds.com/products/draftsight/

Supreme Commander 2 - Square Enix (2010)
http://bugs.winehq.org/show_bug.cgi?id=23593

GTA IV (Scott on this)
http://appdb.winehq.org/objectManager.php?sClass=application&iId=8757

## Free non-game apps ##

tbd