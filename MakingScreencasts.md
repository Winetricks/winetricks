I haven't found the perfect method yet, but here are the key problems, and what I'm doing at the moment.

## Challenges ##

  * If you use too high a resolution, the viewer won't be able to read the text of the install process
  * If you use too low a resolution, aliasing will make the game look bad
  * If the game changes video modes, ffmpeg aborts
  * If you need to concatenate two video files, you may have to re-encode them into mpeg-1, mpeg-2 DS, or DV before concatenating them (see http://www.ffmpeg.org/faq.html#SEC27 ), which can introduce more compression artifacts.

## What I currently do ##

I use the tips at https://wiki.jasig.org/display/JSG/Screencasting+In+Ubuntu

i.e. his ffmpeg script for recording, and avidemux for editing.
