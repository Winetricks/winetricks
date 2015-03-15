Winetricks has special support for installing Steam games,
so it's pretty easy to add new ones.  Here's an example:

```
w_metadata alienswarm_steam games \
    title="Alien Swarm (Steam)" \
    publisher="Valve" \
    year="2010" \
    media="download" \
    installed_exe1="$W_PROGRAMS_X86_WIN/Steam/steamapps/common/alien swarm/swarm.exe"

load_alienswarm_steam()
{
    w_steam_install_game 630 "Alien Swarm"
}

```

The two parameters to w\_steam\_install\_game are the steam game id,
which is the interesting bit of the game's url at steampowered.com
(for Alien Swarm, http://store.steampowered.com/app/630, it's 630 )
and the game's Steam name (so winetricks can recognize the install windows).

Easy as Goo pie!

The only ugly part is that, for the moment, you have to set your steam username and password before running winetricks, e.g.

```
export W_STEAM_ID=myname
export W_STEAM_PASSWORD=mypassword
winetricks alienswarm_steam
```

This will be fixed soon, such that winetricks prompts for those nicely and
caches them for you.