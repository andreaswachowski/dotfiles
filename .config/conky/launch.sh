#!/bin/bash
# Start (or restart) both conky columns. Pass -n to skip the 1 s startup pause.
cd "$(dirname "$0")" || exit 1
# conky 1.24 can ignore SIGTERM (hangs on a futex), so fall back to SIGKILL
if pkill -x conky; then
    sleep 1
    pkill -KILL -x conky
fi
if [ "$1" = "-n" ]; then
    pause_flag=""
else
    pause_flag="--pause=1"
    echo "Conky waiting 1 seconds to start..."
fi
for config in conky.conf conky-fs.conf; do
    if conky --daemonize --quiet $pause_flag --config="$PWD/$config"; then
        echo "Started $config"
    else
        echo "Failed $config"
    fi
done

# Google Calendar column: disabled because it needs pipenv and a service account key
# (google_calendar_key.json), neither of which is set up on this machine.
#conky --daemonize --quiet $pause_flag --config="$PWD/google_calendar.conf"
