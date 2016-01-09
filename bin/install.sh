#!/usr/bin/env bash

# Start in the directory where this script is located
pushd "$(dirname "${BASH_SOURCE}")" 1> /dev/null;

# Load Helper Functions
source ./functions.sh;

# Display banner
h1 "Install";

# Hand off to other Scripts

readp "Install VMWare Tools?" VMWARE;
readp "Install applications?" APPS;
readp "Configure default settings?" CONFIG;

if [[ $VMWARE =~ ^[Yy]$ ]]; then
 	# sh ./vmware-tools.sh;
 	sudo ./vmware-tools.sh;
fi;

if [[ $APPS =~ ^[Yy]$ ]]; then
 	sh ./brew.sh;
fi;

if [[ $CONFIG =~ ^[Yy]$ ]]; then
 	sh ./config.sh;
fi;


# Pop back to our original directory
popd 1> /dev/null;

echo