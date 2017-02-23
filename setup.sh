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

echo "Installing git"
sudo apt-get install git

# Setup vim
echo "Installing vim prereqs"
sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git

echo "Checking out vim"
git checkout https://github.com/vim/vim.git
(cd vim &&
    git checkout "v8.0.0206" &&
	./configure --with-features=huge \
	            --enable-multibyte \
	            --enable-rubyinterp=yes \
	            --enable-pythoninterp=yes \
	            --with-python-config-dir=/usr/lib/python2.7/config \
	            --enable-python3interp=yes \
	            --with-python3-config-dir=/usr/lib/python3.5/config \
	            --enable-perlinterp=yes \
	            --enable-luainterp=yes \
	            --enable-gui=gtk2 \
			    --with-x \
			    --enable-cscope \
                --prefix=/usr &&
	make -j8 &&
    sudo make install)

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

echo "Installing vimdiff as git difftool"
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff

# Setup terminal profile
echo "IMPORTANT: CHANGE THE FONT TO MENLO FOR POWERLINE"
read


cd $ORIG_DIR
echo "Done"
