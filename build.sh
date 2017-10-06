#!/bin/bash
if [ -d /vagrant ] ; then
    echo Vagrant build detected
    export IS_VAGRANT=1
    mkdir -p $HOME/.cache
    cp -f /vagrant/chapter* /vagrant/*.patch ~/
    cp -f SW_binaries_for_Xperia_AOSP_M_MR1_3.10_v12_loire.zip $HOME/.cache/
fi

echo 4.1 Setting up required environment variables
cat <<'EOF' > $HOME/.hadk.env
export PLATFORM_SDK_ROOT="/srv/mer"
export ANDROID_ROOT="$HOME/hadk"
export VENDOR="sony"
export DEVICE="f5121"
export HABUILD_DEVICE="suzu"
# ARCH conflicts with kernel build
export PORT_ARCH="armv7hl"

export LC_ALL=C
export LANG=C
export LANGUAGE=C
EOF

set -e -x
shopt -s expand_aliases
. $HOME/.hadk.env

cat <<'EOF' >> $HOME/.mersdkubu.profile
function hadk() { source $HOME/.hadk.env; echo "Env setup for $DEVICE"; }
export PS1="HABUILD_SDK [\${DEVICE}] $PS1"
hadk
EOF
cat <<'EOF' >> $HOME/.mersdk.profile
function hadk() { source $HOME/.hadk.env; echo "Env setup for $DEVICE"; }
hadk
EOF

echo 4.2 Setup the Platform SDK
sudo mkdir -p $PLATFORM_SDK_ROOT/sdks/sfossdk
[ -x $PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot ] || \
    curl -k -O http://releases.sailfishos.org/sdk/installers/latest/Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2
[ -x $PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot ] || \
    sudo tar --numeric-owner -p -xjf Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2 -C $PLATFORM_SDK_ROOT/sdks/sfossdk
echo "export PLATFORM_SDK_ROOT=$PLATFORM_SDK_ROOT" >> ~/.bashrc
echo 'alias sfossdk=$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot' >> ~/.bashrc
echo 'PS1="PlatformSDK $PS1"' > ~/.mersdk.profile
# Not needed for batch build
# echo '[ -d /etc/bash_completion.d ] && for i in /etc/bash_completion.d/*;do . $i;done'  >> ~/.mersdk.profile

alias sfossdk="$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot"
alias ubu_chrt="$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot ubu-chroot -r $PLATFORM_SDK_ROOT/sdks/ubuntu"

echo 4.3 Preparing the Platform SDK
sfossdk sudo zypper -n in android-tools createrepo zip

echo 4.4.1 Downloading and Unpacking Ubuntu Chroot
TARBALL=ubuntu-trusty-android-rootfs.tar.bz2
[ -f $TARBALL ] || curl -O http://img.merproject.org/images/mer-hybris/ubu/$TARBALL
UBUNTU_CHROOT=$PLATFORM_SDK_ROOT/sdks/ubuntu
sfossdk sudo mkdir -p $UBUNTU_CHROOT
sfossdk "[ -f $UBUNTU_CHROOT/etc/debian_version ] || sudo tar --numeric-owner -xjf $TARBALL -C $UBUNTU_CHROOT"

echo 5. Ubuntu Chroot
sudo cp -f chapter5-ubu.sh ~/chapter5-ubu.sh || \
    sudo cp -f /vagrant/chapter5-ubu.sh ~/chapter5-ubu.sh

sudo chmod a+x ~/chapter5-ubu.sh
ubu_chrt ~/chapter5-ubu.sh

echo 6. SETTING UP SCRATCHBOX2 TARGET == 2.1.1.24
[ -f ~/.cache/Jolla-2.1.1.24-Sailfish_SDK_Target-armv7hl.tar.bz2 ] || \
    wget http://releases.sailfishos.org/sdk/latest/targets-1707/Jolla-2.1.1.24-Sailfish_SDK_Target-armv7hl.tar.bz2 -O ~/.cache/Jolla-2.1.1.24-Sailfish_SDK_Target-armv7hl.tar.bz2
sfossdk sudo zypper -n in -t pattern Mer-SB2-armv7hl

sfossdk sdk-assistant list | grep -q SailfishOS-armv7hl || \
    sfossdk sdk-assistant -y create SailfishOS-armv7hl \
    ~/.cache/Jolla-2.1.1.24-Sailfish_SDK_Target-armv7hl.tar.bz2
    # http://releases.sailfishos.org/sdk/latest/Jolla-latest-Sailfish_SDK_Target-armv7hl.tar.bz2

sfossdk sdk-manage --use-chroot-as $(id -un) --target --list | grep -q $VENDOR-$DEVICE-$PORT_ARCH || \
    sfossdk sdk-manage --use-chroot-as $(id -un) --target --install $VENDOR-$DEVICE-$PORT_ARCH Mer-SB2-armv7hl \
    ~/.cache/Jolla-2.1.1.24-Sailfish_SDK_Target-armv7hl.tar.bz2
    # http://releases.sailfishos.org/sdk/latest/Jolla-latest-Sailfish_SDK_Target-armv7hl.tar.bz2

cat > sb2_hello_world.c << 'EOF'
#include <stdlib.h>
#include <stdio.h>
int main(void) {
printf("SB2 TEST OK\n");
return EXIT_SUCCESS;
}
EOF
sfossdk "sb2 -t $VENDOR-$DEVICE-$PORT_ARCH gcc sb2_hello_world.c -o sb2_hello_world && sb2 -t $VENDOR-$DEVICE-$PORT_ARCH ./sb2_hello_world" | grep 'SB2 TEST OK'

echo Ignore chapter 7, but do the following instead
sfossdk bash chapter7-sdk1.sh
ubu_chrt bash chapter7-ubu1.sh
sfossdk bash chapter7-sdk2.sh
ubu_chrt bash chapter7-ubu2.sh
sfossdk bash chapter7-sdk3.sh

sfossdk bash chapter8-sdk1.sh

[ -z "$IS_VAGRANT" ] && cp -rf /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1 /vagrant/
