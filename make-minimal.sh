#!/bin/bash

if [ -d root ]; then
    echo "rm previous root..."
    rm -r root
fi

if [ -f root.tar.xz ]; then
    rm root.tar.xz
fi

echo "create dirs..."
mkdir -p root/usr/{bin,lib}
mkdir -p root/etc
mkdir -p root/tmp

ln -s ./usr/bin root/bin
ln -s ./usr/lib root/lib
ln -s ./bash root/bin/sh

export INSTALL_ROOT=$PWD/root

echo "install bulge..."
cp ../bulge/target/debug/bulge root/usr/bin
mkdir -p ${INSTALL_ROOT}/etc/bulge/databases/cache

bulge=root/usr/bin/bulge
${bulge} setup

echo "install pkgs..."
${bulge} s
yes | ${bulge} gi base

echo "compress..."
cd root
tar cfJ ../root.tar.xz ./*
cd ..

