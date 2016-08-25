#!/usr/bin/liquidsoap -v

set("log.file.path","/home/studio/logs/<script>.log")

set("init.daemon",true)
set("init.daemon.pidfile",true)
set("init.daemon.pidfile.path","/home/studio/<script>.pid")

set("log.stdout",false)
set("log.syslog",false)

set("harbor.bind_addr","0.0.0.0")

def crossfade(t,a,b)
  add(normalize=false, [sequence([ blank(duration=t/1.0), fade.initial(duration=t,b) ]), fade.final(duration=t,a)])
end

linein = delay(0.5,output.alsa(normalize(input.alsa(bufferize=false))))
commercial = input.harbor("commercials", port=8000, password="secret_pwd_for_commercials")

finalized = fallback(track_sensitive=false, transitions=[crossfade(1.0),crossfade(1.0)], [commercial,linein])

output.shoutcast(
	%mp3,
	fallible=true,
	host="broadcast.streamcastify.com", port=8000, password="secret", 
	name="My Internet Radio Stations",
	genre="Misc Talk",
    url="https://www.streamcastify.com/stations/live80s/",
	mksafe(finalized)
)

output.alsa(fallible=true,bufferize=false,finalized)