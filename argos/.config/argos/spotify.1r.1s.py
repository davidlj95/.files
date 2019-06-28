#!/usr/bin/env python3

# This is a simple Spotify extension that displays the currently playing/paused song with artist and title. There are also some simple controls to pause/play, go to next or previous song and to exit spotify. To kill the spotify application, a separate python script is used. If spotify isn't running, "Spotify is not running" is displayed together with a button to start Spotify.
# Kill script:
#import sys
#import psutil
#
#for proc in psutil.process_iter():
#        if proc.name() == sys.argv[1]:
#            proc.kill()
#
# ![Spotify extension screenshot running](https://i.imgur.com/QwXCofR.png)
# ![Spotify extension screenshot not running](https://i.imgur.com/Re7fPg7.png)
# Made by [Skillzore](https://github.com/Skillzore)

import dbus
import psutil

maxDisplayLength = 20
detailColor = "#1DB954" # Spotify green
startUri = 'spotify:track:3sXHMpriGlbFhMdJT6tzao'

# Check if process name is running
def isRunning(name):
    for proc in psutil.process_iter():
        if(proc.name() == name):
            return True

# Shorten strings longer than maxDisplayLength to maxDisplayLength and add ... after
def maybeShorten(string):
    if(len(string) > maxDisplayLength):
        return string[:maxDisplayLength] + "..."
    else:
        return string

# Replace special characters in string with the corresponding html entity number
def cleanSpecialChars(string):
    return string.replace("&","&#38;").replace("|","&#124;")

# Build menu item
if(isRunning("spotify")):
    session_bus = dbus.SessionBus()
    spotify_bus = session_bus.get_object('org.mpris.MediaPlayer2.spotify', '/org/mpris/MediaPlayer2')
    spotify_properties = dbus.Interface(spotify_bus, 'org.freedesktop.DBus.Properties')
    metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
    playbackStatus = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')

    if(len(metadata['xesam:artist']) > 0 and len(playbackStatus) > 0):
        artist = cleanSpecialChars(metadata['xesam:artist'][0])
        album = cleanSpecialChars(metadata['xesam:album'])
        title = cleanSpecialChars(metadata['xesam:title'])

        finalArtist = maybeShorten(artist)
        finalAlbum = maybeShorten(album)
        finalTitle = maybeShorten(title)

        # Edit this string to change the display
        finalString = playbackStatus + ": " + finalArtist + " &#124; " + finalTitle

        print(finalString + " | iconName=spotify")

        print("---")

        # Print full details in menu
        print("Artist: " + artist + " | color=" + detailColor)
        print("Album: " + album + " | color=" + detailColor)
        print("Title: " + title + " | color=" + detailColor)

        print("---")

        # show play or pause button depending on current status
        if(playbackStatus == "Paused" or playbackStatus == "Stopped"):
            print("Play | iconName=media-playback-start bash='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play' terminal=false")
        else:
            print("Pause | iconName=media-playback-pause bash='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause' terminal=false")

        # next button
        print("Next | iconName=media-skip-forward bash='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next' terminal=false")

        # previous buton
        print("Previous | iconName=media-skip-backward bash='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous' terminal=false")

        # exit spotify
        print("Exit Spotify | iconName=application-exit bash='python3 /home/simonc/.config/argos/.kill.py spotify' terminal=false")

    else:
        print("Nothing is playing | iconName=spotify")
        print("---")
        print("Play Favvos | iconName=media-playback-start bash='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.OpenUri string:" + startUri + "' terminal=false")
        print("Exit Spotify | iconName=application-exit bash='python3 /home/simonc/.config/argos/.kill.py spotify' terminal=false")

else:
    print("Spotify is not running | iconName=spotify")
    print("---")
    print("Start Spotify | iconName=spotify bash='spotify U%' terminal=false")
