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
$PASS
$PASS
EOF

#set the root password
echo root | passwd <<EOF
$ROOT
$ROOT
EOF

#bootctl install
bootctl install

#echo disk UUID for /dev/sda2 into /boot/loader/entries/arch.conf
blkid /dev/sda2 | awk -F\" '{print $2}' > /boot/loader/entries/arch.conf
nano /boot/loader/entries/arch.conf

#finish creating /boot/loader/entries/arch.conf and add correct hooks to mkinitcpio.conf
nano /boot/loader/entries/arch.conf
sed -i 's/HOOKS="base udev autodetect modconf block filesystems keyboard fsck"/HOOKS="base udev autodetect modconf block keymap encrypt lvm2 resume filesystems keyboard fsck"/g' ~/etc/mkinitcpio.conf

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

#set the hostname
echo 'Enter host name:'
read -p 'Enter hostname: ' HOSTN

#echo the hostname to /etc/hostname
echo '$HOSTN' > /etc/hostname

#prepare /etc/hosts file for user creation via nano
echo '# Write tab then $HOSTN after localhost' >> /etc/hosts
nano /etc/hosts

#enable NetworkManager at boot
systemctl enable NetworkManager

#add repo keys for the pipelight repository
pacman-key -r E49CC0415DC2D5CA
pacman-key --lsign-key E49CC0415DC2D5CA

#add the aur and pipelight repositories to /etc/pacman.conf
echo <<EOF
#multilib
[multilib]
Include = /etc/pacman.d/mirrorlist

#arch linux user repository
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch

#pipelight for silverlight and windows flashplayer
[pipelight]
Server = http://repos.fds-team.de/stable/arch/$arch
EOF >> /etc/pacman.conf

#sync repositories and update
pacman -Syyu --noconfirm

#fun stuff
echo 'Defaults insults' >> /etc/sudoers

#pacman progress indicator
sudo sed -i '/^\#VerbosePkgLists/aILoveCandy' /etc/pacman.conf

#pacman colors
sed -i 's/#Color/Color/g' /etc/pacman.conf

#.bash_profile

#autostart X11
#just uncomment to activate after installing window manager or Desktop
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx ' >> /home/$USER/.bash_profile

#alias pastebin
#usage:
# cat /path/to/file | pastebin
echo 'alias pastebin="curl -F c=@- https://ptpb.pw/" ' >> /home/$USER/.bash_profile
