if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") <file>"
  exit 1
fi

KEYNAME=$1
KEYFILE=$HOME/.ssh/$KEYNAME

if [ -f "$KEYFILE" ]; then
  $KEYFILE exists. Aborting
  exit 1
fi

ssh-keygen -b 256 -t ed25519 -f "$KEYFILE" -C "$(whoami)@$(hostname)"
