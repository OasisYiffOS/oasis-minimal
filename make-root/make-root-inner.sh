#!/bin/bash

echo "oasisYiffOS MkMinimal v2.0"

if [ -d root ]; then
    echo "rm previous root..."
    rm -r root
fi

if [ -f root.tar.xz ]; then
    rm root.tar.xz
fi

echo "create dirs..."
export R=$PWD/root
mkdir -p $R

mkdir -pv $R/{etc,var}
mkdir -pv $R/usr/{bin,lib,sbin}
for i in bin lib sbin; do
    ln -sv usr/$i $R/$i
done
case $(uname -m) in
    x86_64) mkdir -pv $R/lib64 ;;
esac

mkdir -pv $R/{dev,proc,sys,run}
#mount -v --bind /dev $R/dev
#mount -vt proc proc $R/proc
#mount -vt sysfs sysfs $R/sys

mkdir -pv $R/{boot,home,mnt,opt,srv}
mkdir -pv $R/etc/{opt,sysconfig}
mkdir -pv $R/lib/firmware
mkdir -pv $R/media/{floppy,cdrom}
mkdir -pv $R/usr/{,local/}{include,src}
mkdir -pv $R/usr/local/{bin,lib,sbin}
mkdir -pv $R/usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv $R/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv $R/usr/{,local/}share/man/man{1..8}
mkdir -pv $R/var/{cache,local,log,mail,opt,spool}
mkdir -pv $R/var/lib/{color,misc,locate}

install -dv -m 0750 $R/root
install -dv -m 1777 $R/tmp $R/var/tmp

echo "init passwd and group..."

echo "root:x:0:0:root:/root:/bin/bash" > $R/etc/passwd
echo "bin:x:1:1:bin:/dev/null:/usr/bin/false" >> $R/etc/passwd
echo "daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false" >> $R/etc/passwd
echo "messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false" >> $R/etc/passwd
echo "systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false" >> $R/etc/passwd
echo "systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false" >> $R/etc/passwd
echo "systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false" >> $R/etc/passwd
echo "systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false" >> $R/etc/passwd
echo "systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false" >> $R/etc/passwd
echo "systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false" >> $R/etc/passwd
echo "systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false" >> $R/etc/passwd
echo "uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false" >> $R/etc/passwd
echo "systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false" >> $R/etc/passwd
echo "nobody:x:99:99:Unprivileged User:/dev/null:/usr/bin/false" >> $R/etc/passwd

echo "root:x:0:" > $R/etc/group
echo "bin:x:1:daemon" >> $R/etc/group
echo "sys:x:2:" >> $R/etc/group
echo "kmem:x:3:" >> $R/etc/group
echo "tape:x:4:" >> $R/etc/group
echo "tty:x:5:" >> $R/etc/group
echo "daemon:x:6:" >> $R/etc/group
echo "floppy:x:7:" >> $R/etc/group
echo "disk:x:8:" >> $R/etc/group
echo "lp:x:9:" >> $R/etc/group
echo "dialout:x:10:" >> $R/etc/group
echo "audio:x:11:" >> $R/etc/group
echo "video:x:12:" >> $R/etc/group
echo "utmp:x:13:" >> $R/etc/group
echo "usb:x:14:" >> $R/etc/group
echo "cdrom:x:15:" >> $R/etc/group
echo "adm:x:16:" >> $R/etc/group
echo "messagebus:x:18:" >> $R/etc/group
echo "systemd-journal:x:23:" >> $R/etc/group
echo "input:x:24:" >> $R/etc/group
echo "mail:x:34:" >> $R/etc/group
echo "kvm:x:61:" >> $R/etc/group
echo "systemd-journal-gateway:x:73:" >> $R/etc/group
echo "systemd-journal-remote:x:74:" >> $R/etc/group
echo "systemd-journal-upload:x:75:" >> $R/etc/group
echo "systemd-network:x:76:" >> $R/etc/group
echo "systemd-resolve:x:77:" >> $R/etc/group
echo "systemd-timesync:x:78:" >> $R/etc/group
echo "systemd-coredump:x:79:" >> $R/etc/group
echo "uuidd:x:80:" >> $R/etc/group
echo "systemd-oom:x:81:" >> $R/etc/group
echo "wheel:x:97:" >> $R/etc/group
echo "nogroup:x:99:" >> $R/etc/group
echo "users:x:999:" >> $R/etc/group

echo "/bin/bash" > $R/etc/shells

touch $R/var/log/{btmp,lastlog,faillog,wtmp}
chmod -v 664  $R/var/log/lastlog
chmod -v 600  $R/var/log/btmp

echo "download and setup bulge..."
export INSTALL_ROOT=$R
bulge=$PWD/bulge

if [ -f ${bulge} ]; then
    rm ${bulge} 
fi

wget -v -O ${bulge} https://yiffos.elysiumorpheus.com/bulge --read-timeout=5
chmod +x ${bulge}

INSTALL_ROOT=$R ${bulge} setup
INSTALL_ROOT=$R yes | ${bulge} gi base

ln -s ./bash $R/bin/sh

# CERTS
#$R/sbin/make-ca -g -D $R

# TODO bulge package is broken
cp ${bulge} $R/bin

# TODO this won't be needed later
# but as OasisYiffOS in its current state has some packages that it can't build
# so the package never gets downloaded and bulge crashes when trying to delete it
# borken pacakges:
# nss
rm -r $R/tmp/*

echo "compress..."
cd root
tar cfJ ../root.tar.xz ./*
cd ..

