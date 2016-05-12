#!/bin/bash

#install some packages
pacman -S intel-ucode networkmanager

#user accounts
#set the username and password, set the root password
read -p 'Enter username: ' USER
read -p 'Enter password: ' PASS
read -p 'Enter root password: ' ROOT

#uncomment the wheel group to /etc/sudoers
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

#create the user and give them sudoer permissions
useradd -mG wheel -s /bin/bash $USER

#set the password for the newly created user
echo $USER | passwd <<EOF
$PASS:$PASS
EOF

#set the root password
echo root | passwd <<EOF
$ROOT:$ROOT
EOF

#bootctl install
bootctl install

#echo disk UUID for /dev/sda2 into /boot/loader/entries/arch.conf
blkid /dev/sda2 | awk -F\" '{print $2}' > /boot/loader/entries/arch.conf
nano /boot/loader/entries/arch.conf

#finish creating /boot/loader/entries/arch.conf and add correct hooks to mkinitcpio.conf
nano /boot/loader/entries/arch.conf
sed -i 's/HOOKS="base udev autodetect modconf block filesystems keyboard fsck"/HOOKS="base udev autodetect modconf block keymap encrypt lvm2 resume filesystems keyboard fsck"/g' ~/Desktop/testfile
set -x; sed s/HOOKS=”base udev autodetect modconf block filesystems keyboard fsck”/HOOKS=”base udev autodetect modconf block keymap encrypt lvm2 resume filesystems keyboard fsck”/g’ ~/Desktop/testfile; set +x

#update systemd-boot and mkinitcpio.conf
bootctl update
mkinitcpio -p linux

#set the locale, timezone, and keymap
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
ln -s /usr/share/zoneinfo/America/Detroit
hwclock --systohc --utc
echo 'KEYMAP=us' > /etc/vconsole.conf

#networking

read -p 'Enter hostname: ' HOSTN

systemctl enable NetworkManager

echo '$HOSTN' > /etc/hostname

nano /etc/hosts

#install multilib and yaourt AUR access
sed -i 's/#Color/Color/g' /etc/pacman.conf

echo '[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf

#install packages
pacman -S yaourt aurvote
