#!/bin/bash

# set -v

# Start in the directory where this script is located
pushd "$(dirname "${BASH_SOURCE}")" 1> /dev/null;

# Load Helper Functions
source ./functions.sh;

# Display banner
h1 "Sublime Text 3 Settings";


LOCAL=~/Library/Application\ Support/Sublime\ Text\ 3
SHARED=~/Dropbox/Sync/Sublime\ Text\ 3

# Create shared settings from initial machine
function initialize {
	h2 "Initializing ST3 settings";

	if [ -h "$LOCAL/Packages/User" ]; then
	 	error "Cannot continue. Sublime settings are already linked."
		error "$LOCAL/Packages/User -> $SHARED/Packages/User"
		echo
	  	exit 1
	fi

	if [ -d "$SHARED/Packages/User" ]; then
	 	echo "Sublime shared settings already exist at $SHARED/Packages/User."
	 	echo
		while true; do
		    readp "Do you wish to cotinue and overwrite the existing settings? (y/n) " yn
		    echo
		    case $yn in
		        [Yy]* ) 
					rm -rf "$SHARED/Packages/User"
					break;;
		        [Nn]* ) exit 1;;
		        * ) echo "Please answer yes or no. ";;
		    esac
		done
	fi

	mkdir -p "$SHARED/Packages"
	info "Created $SHARED/Packages"

	cd "$LOCAL/Packages"
	mv -f User "$SHARED/Packages"
	info "Moved   $LOCAL/Packages/User -> $SHARED/Packages/User"

	link
}

# Link to existing shared setting
function link {
	h2 "Linking ST3 settings"

	if [ ! -d "$SHARED/Packages/User" ]; then
	 	error "Cannot continue. Sublime shared settings do not exist."
		error "$SHARED/Packages/User"
  	exit 1
	fi


	test -d "$LOCAL/Local" || mkdir -p "$LOCAL/Local"
	test -d "$LOCAL/Packages" || mkdir -p "$LOCAL/Packages"
	test -d "$LOCAL/Installed Packages" || mkdir -p "$LOCAL/Installed Packages"


	# Copy Licence
	test -f "$LOCAL/Local/License.sublime_license" || cp "$SHARED/Local/License.sublime_license" "$LOCAL/Local/License.sublime_license"

	# Copy Package Control package
	test -f "$LOCAL/Installed Packages/Package Control.sublime-package" || curl -fsSL https://packagecontrol.io/Package%20Control.sublime-package --output "$LOCAL/Installed Packages/Package Control.sublime-package"

#	if [ ! -d "$LOCAL/Packages" ]; then
#	 	mkdir -p "$LOCAL/Packages"
#        echo "Created $LOCAL/Packages"
	# fi

	cd "$LOCAL/Packages"
	rm -rf User
	info "Removed $LOCAL/Packages/User"

	ln -s "$SHARED/Packages"/User
	info "Linked  $LOCAL/Packages/User -> $SHARED/Packages/User"
}

# Unlink from  shared settings
function unlink {
	h2 "Unlinking ST3 settings"

	if [ ! -h "$LOCAL/Packages/User" ]; then
	 	error "Cannot continue. Sublime settings not linked."
		error "$LOCAL/Packages/User"
	  exit 1
	fi

	cd "$LOCAL/Packages"
	rm -rf User
	info "Removed $LOCAL/Packages/User"

	cd "$SHARED/Packages"
	cp -r User "$LOCAL/Packages"
	info "Copied  $SHARED/Packages/User -> $LOCAL/Packages/User"
}


while getopts ":iu" opt; do
  case $opt in
    i)
		initialize
		exit
    	;;
    u)
		unlink
		exit
    	;;
    \?) 
		echo "Invalid option: -$OPTARG" >&2
  esac
done

link
echo