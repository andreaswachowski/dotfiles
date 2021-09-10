#!/usr/bin/env bash

while (( $# > 0 )); do
  scp "$1" proxmox:/nfs_docker/calibre/upload/
  shift
done
