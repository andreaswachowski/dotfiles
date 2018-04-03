echo \# After brew-installing bash 4, set it up as default shell:
echo "sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'"
echo \# Change to the new shell:
echo chsh -s /usr/local/bin/bash 
echo \# Reboot.
