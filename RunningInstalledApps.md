## Running Apps from the system menu ##

Once you've installed, say, Alien Swarm, you should be able
to find it in the normal system menus.  For instance, in
Ubuntu 10.10, it's in Applications / Wine / Programs / Steam / Alien Swarm.

## Running Apps from the Commandline ##

If you add the aliases mentioned in CommandlineTips to your .bashrc,
you can then start Alien Swarm like this:
```
  prefix alienswarm
  goc
  wine cmd /c run-alienswarm.bat
```

If you can't remember the names of your wineprefixes, you can see them with the command

```
  lsp
```