cd $(dirname $0)
killall conky 2>/dev/null
#font/install
if [ "$1" = "-n" ]; then
    pause_flag=""
else
    pause_flag="--pause=1"
    echo "Conky waiting 1 seconds to start..."
fi
if conky --daemonize --quiet "$pause_flag" --config=/home/andreas/.config/conky/conky.conf ; then
    echo "Started"
else
    echo "Failed"
fi

if conky --daemonize --quiet "$pause_flag" --config=/home/andreas/.config/conky/conky-fs.conf ; then
    echo "Started"
else
    echo "Failed"
fi

if conky --daemonize --quiet "$pause_flag" --config=/home/andreas/.config/conky/google_calendar.conf ; then
    echo "Started"
else
    echo "Failed"
fi
