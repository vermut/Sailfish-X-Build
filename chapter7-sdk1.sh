#!/bin/bash
set -e -x
shopt -s expand_aliases
. $HOME/.hadk.env

cd $ANDROID_ROOT
[ -f droid-local-repo/$DEVICE/droid-hal-$DEVICE/droid-hal-${DEVICE}-devel* ] || rpm/dhd/helpers/build_packages.sh --droid-hal
BRANCH="-upgrade-2.1.3"
[ "$EDGE" == "bleeding" ] && BRANCH=""
[ -d hybris/droid-configs ] && \
    ( cd hybris/droid-configs ; git pull ) || \
    git clone --recursive https://github.com/mer-hybris/droid-config-$DEVICE hybris/droid-configs -b community"$BRANCH"
if [ -z "$(grep community_adaptation $ANDROID_ROOT/hybris/droid-configs/rpm/droid-config-$DEVICE.spec)" ]; then
  sed -i '/%include droid-configs-device/i%define community_adaptation 1\n' $ANDROID_ROOT/hybris/droid-configs/rpm/droid-config-$DEVICE.spec
fi
if [ -z "$(grep patterns-sailfish-consumer-generic $ANDROID_ROOT/hybris/droid-configs/patterns/jolla-configuration-$DEVICE.yaml)" ]; then
  sed -i "/Summary: Jolla Configuration $DEVICE/i- patterns-sailfish-consumer-generic\n- patterns-sailfish-store-applications\n- pattern:sailfish-porter-tools\n" $ANDROID_ROOT/hybris/droid-configs/patterns/jolla-configuration-$DEVICE.yaml
fi
rpm/dhd/helpers/build_packages.sh --configs
