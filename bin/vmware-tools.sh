#!/usr/bin/env bash

# Start in the directory where this script is located
pushd "$(dirname "${BASH_SOURCE}")" 1> /dev/null;

# Load Helper Functions
source ./functions.sh;

# Display banner
h1 "VMWare Tools";

### DO SOMETHING ###
info "Installing VMWare Tools";

# 1 = VMware Tools ISO is mounted from vSphere
# 2 = Download VMware Tools (assumes you can connect to internet)
INSTALL_METHOD=2

# Thanks to Rich Trouton for tip on Tools being available online
VMWARE_TOOLS_DOWNLOAD_URL=http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/8.1.0/3272237/packages/com.vmware.fusion.tools.darwin.zip.tar

# See also
# https://softwareupdate.vmware.com/cds/vmw-desktop/fusion.xml
# https://github.com/autopkg/jessepeterson-recipes/blob/master/VMware/VMwareToolsURLProvider.py
# http://www.virtuallyghetto.com/2015/06/automating-installation-of-vmware-tools-for-mac-os-x.html

# DO NOT MODIFY BEYOND HERE #

VMWARE_TOOLS_INSTALLER_DIR="/Volumes/VMware Tools/Install VMware Tools.app/Contents/Resources"
VMWARE_TOOLS_INSTALLER_FILE="VMware Tools.pkg"

if [ $EUID -ne 0 ]; then
	echo "Please run the script with sudo ..."
	exit 1
fi

if [ ${INSTALL_METHOD} == "1" ]; then
	if [ -d "${VMWARE_TOOLS_INSTALLER_DIR}" ]; then
        	/usr/sbin/installer -pkg "${VMWARE_TOOLS_INSTALLER_DIR}/${VMWARE_TOOLS_INSTALLER_FILE}" -target /
        	echo "Please reboot the system for the installation to complete ..."
	fi
elif [ ${INSTALL_METHOD} == "2" ]; then
	TMP_DIR=/tmp/osx-vmware-tools
	mkdir -p "${TMP_DIR}"

	VMWARE_TOOLS_TAR_FILE=com.vmware.fusion.tools.darwin.zip.tar
	VMWARE_TOOLS_ZIP_FILE=com.vmware.fusion.tools.darwin.zip
	VMWARE_TOOLS_ISO_FILE="payload/darwin.iso"

	cd ${TMP_DIR}

	# Download VMware Tools from online repo
	curl -O "${VMWARE_TOOLS_DOWNLOAD_URL}"

	# Extract the VMware Tools tar file
	tar -xf "${VMWARE_TOOLS_TAR_FILE}"

	# Unzip the VMware Tools zip file
	unzip "${VMWARE_TOOLS_ZIP_FILE}"

	# Mount VMware Tools ISO (similiar to vSphere/ESXi)
	hdiutil attach "${VMWARE_TOOLS_ISO_FILE}"

	# Perform installation
	/usr/sbin/installer -pkg "${VMWARE_TOOLS_INSTALLER_DIR}/${VMWARE_TOOLS_INSTALLER_FILE}" -target /

	# Detach mount & clean up
	hdiutil detach '/Volumes/VMware Tools'
	rm -rf "${TMP_DIR}"
	echo "Please reboot the system for the installation to complete ..."
else
	echo "Invalid Selection"
fi


# Pop back to our original directory
popd 1> /dev/null;

echo