$script = <<SCRIPT
cat <<'EOF' > $HOME/.hadk.env
export PLATFORM_SDK_ROOT="/srv/mer"
export ANDROID_ROOT="$HOME/hadk"
export VENDOR="lge"
export DEVICE="hammerhead"
# ARCH conflicts with kernel build
export PORT_ARCH="armv7hl"
EOF

cat <<'EOF' >> $HOME/.mersdkubu.profile
function hadk() { source $HOME/.hadk.env; echo "Env setup for $DEVICE"; }
export PS1="HABUILD_SDK [\${DEVICE}] $PS1"
hadk
EOF
cat <<'EOF' >> $HOME/.mersdk.profile
function hadk() { source $HOME/.hadk.env; echo "Env setup for $DEVICE"; }
hadk
EOF

export PLATFORM_SDK_ROOT=/srv/mer
curl -k -O http://releases.sailfishos.org/sdk/installers/latest/Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2 ;
sudo mkdir -p $PLATFORM_SDK_ROOT/sdks/sfossdk ;
sudo tar --numeric-owner -p -xjf Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2 -C $PLATFORM_SDK_ROOT/sdks/sfossdk  ;
echo "export PLATFORM_SDK_ROOT=$PLATFORM_SDK_ROOT" >> ~/.bashrc
echo 'alias sfossdk=$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot' >> ~/.bashrc ; exec bash ;
echo 'PS1="PlatformSDK $PS1"' > ~/.mersdk.profile ;
echo '[ -d /etc/bash_completion.d ] && for i in /etc/bash_completion.d/*;do . $i;done'  >> ~/.mersdk.profile ;
sfossdk


SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.disksize.size = '50GB'
  
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
  end
  config.vm.provision "shell", inline: $script, privileged: false
end