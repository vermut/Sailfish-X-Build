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
