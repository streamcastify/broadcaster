#!/usr/bin/liquidsoap -v

# Setting a logfile location
set("log.file.path","/home/studio/logs/<script>.log")

# Configure as a server daemon
set("init.daemon",true)
set("init.daemon.pidfile",true)
set("init.daemon.pidfile.path","/home/studio/<script>.pid")

# Diable excessive logging
set("log.stdout",false)
set("log.syslog",false)

# Bind LiquidSoap to work on any network interface avaiable
set("harbor.bind_addr","0.0.0.0")

# Crossfade with audio normalization.
def crossfade(t,a,b)
  add(normalize=false, [sequence([ blank(duration=t/1.0), fade.initial(duration=t,b) ]), fade.final(duration=t,a)])
end

# Set a 5 second delay. You could theoretically interrupt a live stream by disabling the remote server with a hotbutton.
linein = delay(0.5,output.alsa(normalize(input.alsa(bufferize=false))))

# Create a "commercial" input for streaming to it. Use this as DJ mode if you'd like. You can add more easily.
commercial = input.harbor("commercials", port=8000, password="secret_pwd_for_commercials")

# Combine the two inputs, the LineIn and Commercial sources, with Commercial first if avaialble.
finalized = fallback(track_sensitive=false, transitions=[crossfade(1.0),crossfade(1.0)], [commercial,linein])

# Finally, stream to our hosted Shoutcast or Icecast Relay server.
output.shoutcast(
	%mp3,
	fallible=true,
	host="broadcast.streamcastify.com", port=8000, password="secret", 
	name="My Internet Radio Stations",
	genre="Misc Talk",
        url="https://www.streamcastify.com/stations/live80s/",
	mksafe(finalized)
)

# Optionally send the finalized output also to the soundcard's headphone or line out ports for in-studio realtime monitoring.
# The delay above will also be reflected here. To fix, create a second "line in" with no delay, create a matching second finalized feed and
# send that finalized verion to headphones/line out.
output.alsa(fallible=true,bufferize=false,finalized)
