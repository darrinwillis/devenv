#!/bin/bash

# Exit on error
set -e

DIR=`dirname ${BASH_SOURCE[0]}`

GNOMECONF="$DIR/gnome-terminal-conf.xml"
FONTS="$DIR/fonts"
VIMRC="$DIR/vimrc"
DIRCOLORS="$DIR/dircolors"
TERM_COLORS="$DIR/gnome-terminal-colors-solarized"

ORIG_DIR=`pwd`

echo "Setting up development environment"

# Setup vim
echo "Installing vim"
sudo apt-get install vim

echo "Installing fonts"
mkdir -p ~/.fonts
cp $FONTS/* ~/.fonts

echo "Installing Solarized"
cd $DIR
git submodule init
git submodule update

cd $TERM_COLORS
./set_dark.sh

# Move back to the original directory
cd $ORIG_DIR

echo "Installing dircolors fix"
cp $DIRCOLORS ~/.dircolors
eval `dircolors ~/.dircolors`

if [ -e ~/.vim ]; then
    echo "Backing up ~/.vim to ~/.vim.bak"
    mv ~/.vim ~/.vim.bak
fi

mkdir -p ~/.vim/bundle

echo "Installing Vundle"
git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim

if [ -e ~/.vimrc ]; then
    echo "Backing up ~/.vimrc to ~/.vimrc.bak"
    mv ~/.vimrc ~/.vimrc.bak
fi

echo "Installing new .vimrc"
cp $VIMRC ~/.vimrc

echo "Installing plugins"
vim +PluginInstall +qall

grep -vq "set colored-stats on" ~/.inputrc
ret=$?
if [ $ret != "0" ]; then
    echo "Fixing tab complete dircolors"
    echo "set colored-stats on" >> ~/.inputrc
fi

# Setup terminal profile
echo "IMPORTANT: CHANGE THE FONT TO MENLO FOR POWERLINE"

cd $ORIG_DIR
echo "Done"
