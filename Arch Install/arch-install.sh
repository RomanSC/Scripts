#partitioning
lsblk -af
read -p 'Which disk would you like to partition?: ' WHICHDISK
fdisk $WHICHDISK
read -p 'Which partition are you encrypting? (/dev/sda2 for example): ' WHICHPART

#encryption
cryptsetup --verbose --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random luksFormat $WHICHPART

#decryption
echo 'Open the encrypted partition: '
cryptsetup open --type luks $WHICHPART cryptroot

#lvm
pvcreate /dev/mapper/cryptroot
vgcreate vol0 /dev/mapper/cryptroot

#show the user the amount for $SWAPSIZE
free --giga | grep Mem
read -p 'How many gigabytes do you want your swap to be? (Should be the same as the first number after Mem from above.): ' SWAPSIZE
lvcreate --name /dev/mapper/vol0-lv_swap -L $SWAPSIZE'GB' vol0
lvcreate --name /dev/mapper/vol0-lv_root -l 100%FREE vol0

#formatting
read -p 'Which partition is /boot? (For example /dev/sdx1): ' WHICHISBOOT
mkfs.fat -F32 $WHICHISBOOT
mkswap /dev/mapper/vol0-lv_swap
mkfs.ext4 /dev/mapper/vol0-lv_root

#mount and genfstab
mkdir -p /mnt/boot && mount $WHICHISBOOT /mnt/boot
swapon /dev/mapper/vol0-lv_swap
mount /dev/mapper/vol0-lv_root /mnt
genfstab -U -p /mnt >> /mnt/etc/fstab


#pacstrap
echo "Installing the system: "
pacstrap -i /mnt base base-devel intel-ucode networkmanager ufw openssh bash-completion bashdb mlocate zip dosfstools wget git rsync task mtpfs ruby python vim xfce4-session gtk-xfce4-engine xfce4-settings xfce4-panel xfce4-power-manager xfconf xfce4-artwork xfce4-battery-plugin xfce4-datetime-plugin xfce4-notifyd terminator i3-wm rofi compton nautilus dconf-editor redshift gnome-system-monitor gnome-calculator firefox gufw pidgin alsa-utils pulseaudio pavucontrol eog gimp inkscapegvfs-mtp gvfs-gphoto2 vlc libreoffice-still virtualbox virtualbox-host-dkms

#chroot
arch-chroot /mnt /bin/bash/ -c "./chroot.sh"
