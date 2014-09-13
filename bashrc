export PATH=~/dotfiles/bin:$PATH

if [ -f .bashrc.`hostname` ]; then
	source .bashrc.`hostname`
fi
