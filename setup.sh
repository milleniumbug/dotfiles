#!/bin/bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuxo pipefail

# Keys/passwords
sudo add-apt-repository -y ppa:dlech/keepass2-plugins
sudo apt install -y keepass2 xdotool keepass2-plugin-keeagent

# git
sudo apt install git curl
OLD=$(pwd)
mkdir /tmp/hub
cd /tmp/hub
git clone https://gist.github.com/Taytay/4b463d3e7ebf9915107251b3abad7073 hubinst
cd hubinst
chmod +x install_hub.sh
./install_hub.sh
cd "$OLD" && rm -rf /tmp/hub

# Console
sudo apt install -y wget zsh git
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh

# Desktop environment
sudo apt install -y nitrogen rofi i3 wdm ghc cabal python3
sudo cabal install aeson json-stream

# C++ env
sudo apt install -y gcc g++ gdb build-essential git

# C# env


# Multimedia
sudo apt install -y audacity lame
sudo apt install -y youtube-dl
sudo apt install -y xmms2 xmms2-plugin-m3u
OLD=$(pwd)
mkdir /tmp/mp3gain
cd /tmp/mp3gain
git clone https://github.com/milleniumbug/mp3gain
cd mp3gain/mp3gain
make
sudo make install
cd "$OLD" && rm -rf /tmp/mp3gain

sudo apt install -y automake pkg-config libgtk2.0-dev libxmmsclient-dev libxmmsclient-glib-dev intltool
OLD=$(pwd)
mkdir /tmp/lxmus
cd /tmp/lxmus
git clone https://github.com/milleniumbug/lxmusic-mlem
cd lxmusic-mlem
./autogen.sh
./configure
make
sudo make install
cd "$OLD" && rm -rf /tmp/lxmus
