#!/bin/bash
set -e -x
shopt -s expand_aliases
. $HOME/.hadk.env

sudo apt-get install rsync
cd $ANDROID_ROOT/..
mkdir -p syspart
cd syspart
repo init -u git://github.com/mer-hybris/android.git -b syspart-sony-aosp-6.0.1_r80-20170902 --depth=10
repo sync -q --current-branch
(cd rpm; git submodule init; git submodule update)
source build/envsetup.sh
unzip -o $HOME/.cache/SW_binaries_for_Xperia_AOSP_*.zip
export USE_CCACHE=1
lunch aosp_$DEVICE-userdebug
# Adjust XX to your building capabilities, it will be very heavy on RAM if you go for more cores, proceed with care:
make -j1 libnfc-nci bluetooth.default_32 systemtarball
# Go and have a cuppa, as this is going to take some time :)
