# Make this idempotent - don't mount if already mounted
NAS=cumin.spices.hh
NAS=192.168.1.12

# - "nfc" permits to your finder to handle the UTF-8 NFC coding of Linux and Windows instead of Apple UTF-8 NFD (well explained on
#   G**gle), if not used any file or directory named with accents maybe unseen by the finder (where still okay under a terminal
#   session !) (https://wiki.qnap.com/wiki/Mounting_an_NFS_share_from_OS_X)
# - revsport: By default, Mac OS X connects to an NFS server from a "non-privileged" TCP/IP port, that is, ≥ 1024. However, the
#   Turbo Station only accepts connections from a "privileged" TCP/IP port, ≤ 1023. The "resvport" option in the setup causes
#   Mac OS X to use a privileged port.

NFSOPTS=resvport,hard,intr,noac,nfc
sudo mount -o rw,$NFSOPTS $NAS:/data ~/nfs/archives
sudo mount -o $NFSOPTS $NAS:/video ~/nfs/video
