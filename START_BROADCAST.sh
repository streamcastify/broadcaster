#!/bin/bash

# Log activity of serial port, pushing changes to a logfile.
(stty 1200 cs8 -ixon; cat) < /dev/ttyS0 > /home/studio/logs/ttyS0.log &

# Monitor changes to ttyS0.log and run the commercial script on change.
nohup fileschanged -f /home/studio/logs/ttyS0.log  -exec=/home/studio/commercial &

# Run liquidsoap with ON_AIR config.
/usr/bin/liquidsoap /home/studio/ON_AIR.liq

exit 0
