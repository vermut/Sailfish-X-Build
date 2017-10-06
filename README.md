Sailfish X Automated Build Script
===

Requirements:
* Vagrant
* VirtualBox
* VirtualBox plugins
```bash
vagrant plugin install vagrant-disksize
vagrant plugin install vagrant-vbguest
```

Usage
===
Checkout the the repo and run `vagrant up`. In ~8 hours your build will be ready.

Notes
===
You could run into error while getting SW_binaries_for_Xperia_AOSP_M_MR1_3.10_v12_loire.zip.
In that case download it from [here](https://developer.sonymobile.com/downloads/tool/software-binaries-for-aosp-marshmallow-6-0-1-loire/) and put it next to Vagrantfile.

Expected result
===
At the end of successful build console should contain this:
```
==> default: Info: The new image can be found here:
==> default:   /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1/Jolla-2.1.1.26-f5121-armv7hl.ks
==> default:   /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1/Jolla-2.1.1.26-f5121-armv7hl.ks
==> default:   /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1/Jolla-2.1.1.26-f5121-armv7hl.packages
==> default:   /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1/Jolla-2.1.1.26-f5121-armv7hl.urls
==> default:   /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1/Jolla-2.1.1.26-f5121-armv7hl.xml
==> default:   /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1/SailfishOS--my1-2.1.1.26-f5121-0.0.1.1.tar.bz2
==> default:   /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1/extracting-README.txt
==> default:   /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1/hw-release
==> default:   /home/ubuntu/hadk/sfe-f5121-2.1.1.26-my1/sailfish-release
==> default: Info: Finished.
==> default: TODO: umount any /var/tmp/mic/imgcreate-*/ mounts
==> default: + echo TODO: umount any '/var/tmp/mic/imgcreate-*/' mounts
==> default: Last 1
```

and the `sfe-f5121-2.1.1.26-my1` should appear in local directory next to Vagrantfile.
