#!/bin/bash

(stty 1200 cs8 -ixon; cat) < /dev/ttyS0 > /home/studio/logs/ttyS0.log &
nohup /home/studio/MONITOR_COMMERCIALS.sh </dev/null >/dev/null 2>&1 &

exit 0
