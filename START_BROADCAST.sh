#!/bin/bash

(stty 1200 cs8 -ixon; cat) < /dev/ttyS0 > /home/studio/logs/ttyS0.log &
/usr/bin/liquidsoap /home/studio/ON_AIR.liq

exit 0
