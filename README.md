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

Changelog
===
* 2017-10-11: EDGE variable added for cutting and bleeding flavours of the HW adaptation
* 2017-10-10: Switching to blobless builds, you no longer have to download SW binaries to build things, will only need them to flash the image (we recommend to start your dev environment from scratch at this point)
* 2017-10-07: Each repo init below now points to the tagged-manifest.xml, which means a complete re-init, re-sync, and rebuild is required to fix the recent mobile data issue.
* 2017-09-29: Bluetooth is now enabled, you are welcome to test its profiles and fix up as many as you can (ping jusa in IRC for guidance).
* Browser video playback fixed.
* Camera video recording fixed.
* General performance boosted by enabling all 6 CPU cores.
* 2017-09-26: droid-configs has been updated to fix the nothing provides requested droid-hal-version-f5121 error
* 2017-09-23: Starting with HADK v2.0.1, using Platform SDK Target version 2.1.1 is now in force (this also fixes GPS on Sailfish X). You can either rebuild from ground up, or remove your target like so:

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
