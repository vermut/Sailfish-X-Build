#!/bin/bash
set -e -x
shopt -s expand_aliases
. $HOME/.hadk.env

cd $ANDROID_ROOT
echo all | rpm/dhd/helpers/build_packages.sh --mw # select "all" option when asked
DROIDMEDIA_VERSION=$(git --git-dir external/droidmedia/.git describe --tags | sed -r "s/\-/\+/g")
DEVICE=$HABUILD_DEVICE rpm/dhd/helpers/pack_source_droidmedia-localbuild.sh $DROIDMEDIA_VERSION
mkdir -p hybris/mw/droidmedia-localbuild/rpm
cp rpm/dhd/helpers/droidmedia-localbuild.spec hybris/mw/droidmedia-localbuild/rpm/droidmedia.spec
sed -ie "s/0.0.0/$DROIDMEDIA_VERSION/" hybris/mw/droidmedia-localbuild/rpm/droidmedia.spec
mv hybris/mw/droidmedia-$DROIDMEDIA_VERSION.tgz hybris/mw/droidmedia-localbuild
rpm/dhd/helpers/build_packages.sh --build=hybris/mw/droidmedia-localbuild
echo all | rpm/dhd/helpers/build_packages.sh --mw=https://github.com/sailfishos/gst-droid.git

DEVICE=$HABUILD_DEVICE rpm/dhd/helpers/pack_source_audioflingerglue-localbuild.sh
mkdir -p hybris/mw/audioflingerglue-localbuild/rpm
cp rpm/dhd/helpers/audioflingerglue-localbuild.spec hybris/mw/audioflingerglue-localbuild/rpm/audioflingerglue.spec
mv hybris/mw/audioflingerglue-0.0.1.tgz hybris/mw/audioflingerglue-localbuild
rpm/dhd/helpers/build_packages.sh --build=hybris/mw/audioflingerglue-localbuild
echo all | rpm/dhd/helpers/build_packages.sh --mw=https://github.com/mer-hybris/pulseaudio-modules-droid-glue.git

sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R zypper -n in droid-hal-$DEVICE-kernel
sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R zypper -n in --force-resolution droid-hal-$DEVICE-kernel-modules
echo all | rpm/dhd/helpers/build_packages.sh --mw=https://github.com/sailfishos/initrd-helpers
echo all | rpm/dhd/helpers/build_packages.sh --mw=https://github.com/nemomobile/hw-ramdisk
echo all | rpm/dhd/helpers/build_packages.sh --mw=https://github.com/sailfishos/yamui
[ -d hybris/mw/droid-hal-img-boot-$DEVICE ] && \
    ( cd hybris/mw/droid-hal-img-boot-$DEVICE ; git pull ) || \
    git clone --recursive https://github.com/mer-hybris/droid-hal-img-boot-$DEVICE hybris/mw/droid-hal-img-boot-$DEVICE
echo all | rpm/dhd/helpers/build_packages.sh --mw=https://github.com/mer-hybris/droid-hal-img-boot-$DEVICE

sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -R zypper -n in  --force-resolution bluez5-libs-devel
echo all | rpm/dhd/helpers/build_packages.sh --mw=https://github.com/mer-hybris/bluetooth-rfkill-event --spec=rpm/bluetooth-rfkill-event-hciattach.spec

[ -d hybris/droid-hal-version-$DEVICE ] && \
    ( cd hybris/droid-hal-version-$DEVICE ; git pull ) || \
    git clone --recursive https://github.com/mer-hybris/droid-hal-version-$DEVICE hybris/droid-hal-version-$DEVICE
rpm/dhd/helpers/build_packages.sh --version
