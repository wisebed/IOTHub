#! /bin/sh

### BEGIN INIT INFO
# Provides:          delayed_job
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the delayed_job worker for IOTHub
# Description:       starts the delayed_job worker for IOTHub
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#### CHANGE THE LINES BELOW!
PATH_TO_IOTHUB_DELAYED_JOB_SCRIPT=/home/itohub/IOTHub/script/delayed_job
RUBY=`which ruby`
#### CHANGE THE LINES ABOVE!

RUBY PATH_TO_IOTHUB_DELAYED_JOB_SCRIPT "$1"

exit 0