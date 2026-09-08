#!/bin/sh

check_server_availability() {
	remote_server="pve"
	ping -c 1 "$remote_server" >/dev/null 2>&1
	return $?
}

if check_server_availability; then
	rsync -av ~/Mail/ pve:/archives/email
else
	echo "backup_email.sh: pve is not reachable, skipping backup" >&2
	exit 1
fi
