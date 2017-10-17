#!/bin/bash
set -e -x
shopt -s expand_aliases
. $HOME/.hadk.env

echo 4.4.2 Entering Ubuntu Chroot
# $PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot ubu-chroot -r $PLATFORM_SDK_ROOT/sdks/ubuntu
# FIXME: Hostname resolution might fail. This error can be ignored.
# Can be fixed manually by adding the hostname to /etc/hosts
# We'll now install auxilliary packages that are needed in the most
# modern HW Adaptation builds:
sudo apt-get -y update
# bsdmainutils provides `column`, otherwise an informative Android's
# `make modules` target fails
sudo apt-get -y install bsdmainutils
# Add OpenJDK 1.7 VM, and switch to it:
sudo apt-get -y install openjdk-7-jdk
sudo update-java-alternatives -s java-1.7.0-openjdk-amd64
# Add rsync for the way certain HW adaptations package their system
# partition; also vim and unzip for convenience
sudo apt-get -y install rsync vim unzip wget

# ...ignore chapter 5, instead perform the following
git config --global color.ui true
git config --global user.name "Sailfish X Vagrant"
git config --global user.email "sailfish@mailinator.com"

# At this point, install Android's repo tool
sudo wget https://storage.googleapis.com/git-repo-downloads/repo -O /usr/bin/repo
sudo chmod a+x /usr/bin/repo

# Then...
sudo mkdir -p $ANDROID_ROOT
sudo chown -R $USER $ANDROID_ROOT
cd $ANDROID_ROOT
BRANCH="upgrade-2.1.3-"
[ "$EDGE" == "bleeding" ] && BRANCH=""
repo init -u git://github.com/mer-hybris/android.git -b "$BRANCH"hybris-sony-aosp-6.0.1_r80-20170902 -m tagged-manifest.xml
# Adjust X to your bandwidth capabilities
repo sync -q --current-branch --fetch-submodules
(cd rpm; git submodule init; git submodule update)
source build/envsetup.sh
export USE_CCACHE=1
lunch aosp_$DEVICE-userdebug
# Adjust XX to your building capabilities
make -j4 hybris-hal
