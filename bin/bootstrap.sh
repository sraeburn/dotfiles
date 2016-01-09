#!/usr/bin/env bash

# Set DOFTILES from paarameter, using default if neccessary
set +u;
DOTFILES=${1:-~/.dotfiles}
set -u;

# Causes this script to exit if a variable isn't present
set -u

# Ensure command pipes fail if any command fails (e.g. fail-cmd | success-cmd == fail)
set -o pipefail

# Turn off debugging
set +x

# If a command fails, don't exit, just keep on truckin'
set +e

# Display helper functions

function h1() {
	echo
  printf "\033[1;4;33m${1}\033[0m\n";
}

function h2() {
	echo
  printf "\033[4m${1}\033[0m\n";
  echo
}

function info() {
	printf "\033[0;96m${1}\033[0m\n";
}

function warn() {
	printf "\033[0;33m${1}\033[0m\n";
}

function error() {
	printf "\033[1;31m${1}\033[0m\n";
}

function readp() {
  printf "$1 ";
  read -n 1 $2;
  echo;
}



# Display banner
h1 "Bootstrap";

# Install XCode Developer Tools
h2 "Installing XCode Developer Tools";

xcode-select -p > /dev/null;
if [ $? -eq 0 ]
then
	warn "XCode Developer Tools are already installed.";
else
  # https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh
  info "Installing Xcode Command Line Tools...";
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" -v;
fi


# Check out .dotfiles
h2 "Cloning dotfiles repository";

info "Cloning git repository into $DOTFILES ..."

if git clone https://github.com/sraeburn/dotfiles.git $DOTFILES 2> /dev/null;
then info "Git repository cloned";
else
		warn  "Git repository was not cloned";
    cd $DOTFILES;
    info  "Attempting to update existing repository in $DOTFILES";
    git pull origin master;
fi


# Delegate to setup script
info "Running installer...";
sh $DOTFILES/bin/install.sh < /dev/tty;

unset DOTFILES;

