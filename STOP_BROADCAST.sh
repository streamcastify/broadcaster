#!/bin/bash

# Kill the running instance of ON_AIR daemon
/bin/kill  ps axf | grep "/usr/bin/liquidsoap /home/studio/ON_AIR" | grep -v grep | awk '{print "kill -9 " $1}'

# Need command sto accurately also stop logging and file change monitoring.

exit 0
