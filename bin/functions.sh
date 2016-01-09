#!/usr/bin/env bash

function flags() {
	# Causes this script to exit if a variable isn't present
	set -u;

	# Ensure command pipes fail if any command fails (e.g. fail-cmd | success-cmd == fail)
	set -o pipefail;

	# Turn off debugging
	set +x;

	# If a command fails, don't exit, just keep on truckin'
	set +e;
}
flags;

##############################################################
#
# DISPLAY FUNCTIONS
# These functions help format display output
#
##############################################################

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

#●

##############################################################
#
# INPUT FUNCTIONS
# These functions help gather user input
#
##############################################################

function readp() {
	printf "$1 ";
	read -n 1 $2;
	echo;
}
