#!/bin/bash
set -e -x
shopt -s expand_aliases
. $HOME/.hadk.env

cd $ANDROID_ROOT
[ -d external/audioflingerglue ] && \
    ( cd external/audioflingerglue ; git pull ) || \
git clone https://github.com/mer-hybris/audioflingerglue external/audioflingerglue
[ -d external/droidmedia ] && \
    ( cd external/droidmedia ; git pull ) || \
git clone https://github.com/sailfishos/droidmedia external/droidmedia

source build/envsetup.sh
lunch aosp_$DEVICE-userdebug
make -j4 libdroidmedia_32 minimediaservice minisfservice libaudioflingerglue_32 miniafservice
