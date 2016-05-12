#!/bin/bash

#install some packages
pacman -S intel-ucode networkmanager

#user accounts
#set the username
read -p 'Enter username: ' USER

#uncomment the wheel group to /etc/sudoers
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

#create the user and give them sudoer permissions
useradd -mG wheel -s /bin/bash $USER

#set the password for the newly created user
echo 'Enter user password'
passwd $USER

#set the root password
echo 'Enter root password: '
passwd root

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

#sync repositories and update
pacman -Syyu --noconfirm

#exit
cat <<EOF
++++===========+=?OD8+====+==++++++?+???
++++=======D888DODDD8D8++=+++++++++?????
++++=====NDDD88Z8DZ8D888IO?7+=++++??????
+++++==+8D8O8OOO88O88ZOD8OO8DD++????????
+++++==N88O$OO88OZZZZOOZ8DDD88D7????????
+++++=ND88$7?+?~~~~~++?I7O8DD8DZI???????
++++++?D8I=~::,,,,:~=++IIOO88DOO????????
++++++I8O=:,.,..,,,,~=+?IZ8DDDD????????I
+++++++8Z=~,..,,,,,:==+?I$DDNN8??????I??
+++++++D8=~:,..,.,::~=??77ONNND?????I?II
+++++++7D?7II~:,,,=$O7I77$$DNNI??????III
?+??++++8?~~=+?~,=7I+7Z$$77D87?????I7I77
?????????+??,:=+,=I?=+???I7OI+???IIIZZ78
?????????+:,,,,:,=?+~:~~=?7M7IIII$$??I88
????????$Z,...,::=II=::~+I$?7IIII7777$$$
????????ZD=,..:7~?$I~:=+?I$II7II7$77777$
?????Z88DD=::,,:~~++~~+II7OZ7777I$ZZ$$$Z
?III8888DDD=~~~~~:??7?III$D8DZ$$7Z8OZOZZ
II78DDDDDDD8+=~=~=+I??7$Z$DDNNZZ$ZO$$ZZO
ZDDDDDDDNDD88?=~~~=+I7$?$$ZNNNNNND8ZOZOZ
DDDDDNDDDDD8N?+~~~~=I$??$$ZNNNNNNNNNNDDO
D8DDDDNDDDDDD++II?~,,::+7$$NNNDNNNNNNNNN
DDNDDDDDDDD8N=+~,,:~==?=77$DNNNNNNNNNNNN
8DDDDDDDDDD8D+=~=?I::~?II$NDDNNDNNNNNNNN
D8DDNDD8DDNDD~~~,,,,=??II$DDDNNNNNNNNNNN
********** RomanSC wuz here ************
EOF

echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...
echo ...

exit
