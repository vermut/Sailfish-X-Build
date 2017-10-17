#!/bin/bash
set -e -x
shopt -s expand_aliases
. $HOME/.hadk.env

echo 8.3 Creating and Configuring the Kickstart File
cd $ANDROID_ROOT
HA_REPO="repo --name=adaptation-community-common-$DEVICE-@RELEASE@"
HA_DEV="repo --name=adaptation-community-$DEVICE-@RELEASE@"
KS="Jolla-@RELEASE@-$DEVICE-@ARCH@.ks"
sed \
"/$HA_REPO/i$HA_DEV --baseurl=file:\/\/$ANDROID_ROOT\/droid-local-repo\/$DEVICE" \
$ANDROID_ROOT/hybris/droid-configs/installroot/usr/share/kickstarts/$KS \
> $KS

echo 8.4.1 Modifying a pattern
rpm/dhd/helpers/build_packages.sh --configs

echo 8.5 Building the Image with MIC
# Set the version of your choosing, latest is strongly preferred
# (check with "Sailfish OS version" link above)
# if your sb2 target is 2.1.0, remove it and add 2.1.1 one (check HADK v2.0.1 for link)
RELEASE=2.1.3.5
# EXTRA_NAME adds your custom tag. It doesn't support '.' dots in it!
EXTRA_NAME=-my1
# Always regenerate patterns as they usually get reset during build process
# NB: the next command will output a non-error, safe to ignore it:
# Exception AttributeError: "'NoneType' object has no attribute 'px_proxy_fa..
hybris/droid-configs/droid-configs-device/helpers/process_patterns.sh

echo but instead of the `sudo mic create fs ...` command, perform the following
sudo zypper -n in lvm2 atruncate pigz
sudo ssu ar unbreakmic http://repo.merproject.org/obs/home:/sledge:/branches:/mer-tools:/devel/latest_i486/
sudo zypper -n  ref unbreakmic
sudo zypper -n in droid-tools
sudo zypper -n in --force mic

cd /usr/lib/python2.7/site-packages/mic/
sudo patch -p1 --dry-run < ~/Mic-loop.patch
# ensure above worked, then
sudo patch -p1 < ~/Mic-loop.patch

cd $ANDROID_ROOT
sudo mic create loop --arch=$PORT_ARCH \
    --tokenmap=ARCH:$PORT_ARCH,RELEASE:$RELEASE,EXTRA_NAME:$EXTRA_NAME \
    --record-pkgs=name,url     --outdir=sfe-$DEVICE-$RELEASE$EXTRA_NAME \
    $ANDROID_ROOT/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks

echo TODO: umount any /var/tmp/mic/imgcreate-*/ mounts
