#!/bin/bash
set -e -x
shopt -s expand_aliases
. $HOME/.hadk.env

cd $ANDROID_ROOT/../syspart
BRANCH="-b upgrade-2.1.3"
[ "$EDGE" == "bleeding" ] && BRANCH=""
[ -d droid-system-$DEVICE ] && \
    ( cd droid-system-$DEVICE ; git pull ) || \
    git clone https://github.com/mer-hybris/droid-system-$DEVICE $BRANCH
mb2 -t $VENDOR-$DEVICE-$PORT_ARCH -s droid-system-$DEVICE/rpm/droid-system-$DEVICE.spec build
rm -f $ANDROID_ROOT/droid-local-repo/$DEVICE/droid-system-*.rpm
mv RPMS/droid-system-$DEVICE-0.1.1-1.armv7hl.rpm $ANDROID_ROOT/droid-local-repo/$DEVICE/
createrepo "$ANDROID_ROOT/droid-local-repo/$DEVICE"
sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R zypper ref
