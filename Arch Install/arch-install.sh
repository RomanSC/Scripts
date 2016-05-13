#partitioning
lsblk -af
read -p 'Which disk would you like to partition?: ' WHICHDISK
fdisk $WHICHDISK



#genfstab
genfstab -U -p /mnt >> /mnt/etc/fstab

#pacstrap
echo 'Installing the system: '
pacstrap -i /mnt base base-devel intel-ucode networkmanager ufw openssh bash-completion bashdb mlocate zip dosfstools wget git rsync task mtpfs ruby python vim xfce4-session gtk-xfce4-engine xfce4-settings xfce4-panel xfce4-power-manager xfconf xfce4-artwork xfce4-battery-plugin xfce4-datetime-plugin xfce4-notifyd terminator i3-wm rofi compton nautilus dconf-editor redshift gnome-system-monitor gnome-calculator firefox gufw pidgin alsa-utils pulseaudio pavucontrol eog gimp inkscapegvfs-mtp gvfs-gphoto2 vlc libreoffice-still virtualbox virtualbox-host-dkms

#chroot
arch-chroot /mnt /bin/bash/ -c "./chroot.sh"
