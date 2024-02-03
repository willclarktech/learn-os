#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
command -v shellcheck >/dev/null && shellcheck "$0"

# Run this on the Debian Virtual Machine

PROJECT_DIR=project
GIT_USER_NAME=willclarktech
GIT_USER_EMAIL=willclarktech@users.noreply.github.com
BOCHS_BIOS=BIOS-bochs-latest
BOCHS_CONFIG_DIR=/usr/share/bochs/

## Make Debian usable

mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

sudo apt update
sudo apt install -y vim shellcheck git make curl wget nasm

sudo update-alternatives --set editor /usr/bin/vim.basic
sudo echo "debian ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo ln -s /usr/sbin/parted /usr/bin/ || echo "parted already exists"

## Set git config

git config --global pull.ff only
git config --global user.name $GIT_USER_NAME
git config --global user.email $GIT_USER_EMAIL

## Install binutils and cross-compiler

sudo apt install -y xxd binutils-x86-64-linux-gnu gcc-x86-64-linux-gnu

## Install emulator

sudo apt install -y bochs bochs-x
# bochs package ships with a broken BIOS so we need to replace it
# See https://www.reddit.com/r/linuxquestions/comments/tk4tbk/comment/kh0rchw/
if [ ! -f "./$BOCHS_BIOS" ]; then
	wget https://github.com/ipxe/bochs/raw/master/bios/$BOCHS_BIOS
	sudo cp "$BOCHS_CONFIG_DIR$BOCHS_BIOS"{,.bak}
	sudo cp "$BOCHS_BIOS" "$BOCHS_CONFIG_DIR"
else
	echo "$BOCHS_BIOS already replaced"
fi

## Clone fromQEMUtoTCP repo

ls ./fromQEMUtoTCP || git clone https://github.com/zrthstr/fromQEMUtoTCP.git

## Set up SSH into the VM from host

sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
ip a
