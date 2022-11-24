#!/bin/bash
cd /root/mesa

## v1:
#if [ ! -d mesa ]; then
#	git clone --branch debian-unstable https://salsa.debian.org/xorg-team/lib/mesa.git
#    cd mesa
#    # patch -p1 < ../0001-Add-META_CONNECTOR_TYPE_DPI.patch
#    patch -p1 < ../rockchip_ebc.patch
#    cd ..
#fi
#tar cvf mesa_src.tar.gz mesa
#
#cd mesa
#time DEB_BUILD_OPTIONS="nocheck parallel=2" dpkg-buildpackage -nc --build=binary
#cd ..


# v2: compile from bookwork repository
buildd="build_mesa"
mkdir ${buildd}
cd ${buildd}
apt source mesa
srcdir=`ls -1 | grep mesa | head -1`

cd ${srcdir}
patch -p1 < ../../rockchip_ebc.patch
cd ..

# tar cvf mesa_src.tar.gz ${srcdir}
XZ_OPT='-9' tar -cvJf mesa_src.tar.xz "${srcdir}"

cd ${srcdir}
time DEB_BUILD_OPTIONS="nocheck parallel=4" dpkg-buildpackage --build=binary
cd ..

# save some space and remove unused .deb packages
rm *dbgsym*.deb
rm *dev*.deb
rm mesa-opencl-icd*_arm64.deb


test -d mesa_arm64_debs && rm -r mesa_arm64_debs
mkdir mesa_arm64_debs
mv *.deb mesa_arm64_debs/
mv mesa_src.tar.xz mesa_arm64_debs/

echo "moving directory"

test -d /github/home/mesa_arm64_debs && rm -r /github/home/mesa_arm64_debs

mv mesa_arm64_debs /github/home

ls /github/home/
