#!/bin/bash

# Root check
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Exit on error
set +e

DIR=`dirname ${BASH_SOURCE[0]}`

GNOMECONF='gnome-terminal-conf.xml'

ORIG_DIR=`pwd`

echo "Setting up development environment"

# Setup vim
echo "Installing vim"
sudo apt-get install vim

echo "Backing up ~/.vimrc to ~/.vimrc.bak"
mv ~/.vimrc ~/.vimrc.bak

echo "Installing new .vimrc"
mv $DIR/.vimrc ~/.vimrc

echo "Installing plugins"
vim +PluginInstall +qall

# Setup terminal profile
echo "Applying profile settings"
gconftool-2 --load $DIR/$GNOMECONF

cd $ORIG_DIR
echo "Done"