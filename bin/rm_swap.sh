#!/bin/bash
# I frequently received errors for Library/Shared Application State/*eLicenser* and *flash* directories, because
# they were owned by root with a permission of 700. The solution is in
# http://stackoverflow.com/questions/762348/how-can-i-exclude-all-permission-denied-messages-from-find
# Append ! -perm -g+r,u+r,o+r -prune
/usr/bin/find /Users/andreas ! -perm -g+r,u+r,o+r -prune -mount \( -name '.*.swp' -o -name '.*.un~' \) -ctime -delete +90 2> >(grep -v 'Permission denied' >&2)
