#!/usr/bin/env bash

# Start in the directory where this script is located
pushd "$(dirname "${BASH_SOURCE}")" 1> /dev/null;

# Load Helper Functions
source ./functions.sh;

# Display banner
h1 "Homebrew";

# Packages to install
brews=(
  git
  node
  z
  wget
)

casks=(
  1password
  bitcasa
  dropbox
  evernote
  flash
  google-chrome
  hazel
  sublime-text3
  sourcetree
  path-finder
)

# charles crashplan deltawalker disk-inventory-x eclipse-jee heroku-toolbelt kaleidoscope logitech-myharmony mamp microsoft-office omnifocus omnigraffle transmit vmware-fusion

### DO SOMETHING ###

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


info "Install / Upgrade Homebrew";

function install_homebrew() {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Check/fix installation problems
  set +e
  brew doctor
  set -e

  # Setup casks
  brew install caskroom/cask/brew-cask
  brew tap caskroom/versions

  # Update formulae
  brew update
}

# Install Homebrew

set +e
which brew > /dev/null 2>&1
RET=$?
set -e
if [[ $RET -ne 0 ]]; then
  readp "Install Homebrew package manager (y/N)? " RESPONSE;
  if [[ "$RESPONSE" == "y" ]]; then
    install_homebrew
  fi
else
  echo "Homebrew is already installed, skipping install."
  brew update;
fi

info "Install / Upgrade Formulae";

printf "The following formulae will be installed:\n";
printf ' - %s\n' "${brews[@]}";

readp "Install brews (y/N)? " RESPONSE;
if [[ "$RESPONSE" == "y" ]]; then
  set +e
  brew upgrade;
  for app in ${brews[@]}; do
    brew list $app > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      info "Installing: $app"
      brew install $app
    fi
  done
  set -e
fi


info "Install / Upgrade Casks";

printf "The following casks will be installed:\n";
printf ' - %s\n' "${casks[@]}";

readp "Install casks (y/N)? " RESPONSE;
if [[ "$RESPONSE" == "y" ]]; then
  set +e
  for app in ${casks[@]}; do
    info "Installing: $app";
    brew cask install $app
  done
#  brew cask alfred link
  set -e
fi

h2 "Configure Application";

# Bash
if [[ -x /usr/local/bin/bash ]]; then
  readp "Change default shell to brewed bash (y/N)? " RESPONSE;
  if [[ "$RESPONSE" == "y" ]]; then
    sudo sh -c "echo /usr/local/bin/bash >> /etc/shells"
    sudo chsh -s /usr/local/bin/bash $(whoami)
  fi
fi

# Sublime Text 3
ST3=~/Library/Application\ Support/Sublime\ Text\ 3;

info "Sublime Text 3:";
if [[ ! -d $ST3 ]]; then
    readp "Install default Sublime Text 3 settings (y/N)? " RESPONSE;
    if [[ "$RESPONSE" == "y" ]]; then
       info "Copying default settings";
       cp -rv ../config/Sublime\ Text\ 3 $ST3;
    fi
else 
  warn "No files copied. Target directory exists: $ST3";
  echo;
fi


h2 "Clean Up";
set +e;
mv ~/Applications/* /Applications 2>&1;
echo
set -e;

brew cleanup;
brew cask cleanup;

# Pop back to our original directory
popd 1> /dev/null;

echo


