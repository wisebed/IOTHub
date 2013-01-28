#! /bin/sh

### BEGIN INIT INFO
# Provides:          iothub
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the iothub application server
# Description:       starts the iothub application server
### END INIT INFO

#### CHANGE THE LINE BELOW!
APPDIR=/home/iothub/IOTHub/current/
PASSENGER=/home/iothub/.rvm/gems/ruby-1.9.3-p362/bin/passenger
PORT=8887
USER=iothub
#### CHANGE THE LINE ABOVE!

NAME=iothub
DESC=iothub

test -x $PASSENGER || exit 0

set -e

case "$1" in
  start)
	echo -n "Starting $DESC: "
        cd $APPDIR && $PASSENGER start -p $PORT --user $USER -e production -d
	echo "[OK]."
	;;
  stop)
	echo -n "Stopping $DESC: "
	    cd $APPDIR && $PASSENGER stop -p $PORT
	echo "[OK]."
	;;
  restart|force-reload)
	echo -n "Restarting $DESC: "
        cd $APPDIR && $PASSENGER stop -p $PORT
    echo -n "[stopped] "
     sleep 1
        cd $APPDIR && $PASSENGER start -p $PORT --user $USER -e production -d
	echo "[started]."
	;;
  status)
	cd $APPDIR && $PASSENGER status -p $PORT
	;;
  *)
	echo "Usage: $NAME {start|stop|restart|force-reload|status}" >&2
	exit 1
	;;
esac

exit 0