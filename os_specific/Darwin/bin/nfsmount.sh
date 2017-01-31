# Make this idempotent - don't mount if already mounted
NAS=cumin.spices.hh
#sudo mount -t nfs -o resvport,rw $NAS:/data ~/nfs/archives
sudo mount -t nfs -o resvport,hard,intr $NAS:/video ~/nfs/video
