#!/bin/bash

$dev="$1"
timedatectl set-ntp true

parted /dev/$dev mklabel gpt
parted /dev/$dev uni s mkpart pri 2048 1M
parted /dev/$dev uni s mkpart pri 1M 200M
parted /dev/$dev uni s mkpart pri 200M 400M
parted /dev/$dev uni s mkpart pri 400M 100%

parted /dev/$dev set 1 bios_grub on
parted /dev/$dev set 2 esp on

mkfs.vfat /dev/${dev}2
mkfs.ext4 /dev/${dev}3
pvcreate /dev/${dev}4
vgcreate arch /dev/${dev}4
lvcreate -L8G -n swaplv arch
lvcreate -L20G -n homelv arch
lvcreate -L40G -n rootlv arch
mkfs.xfs -L HOME /dev/mapper/arch-homelv
mkfs.xfs -L ROOT /dev/mapper/arch-rootlv
mkswap -L SWAP /dev/mapper/arch-swaplv

mount /dev/mapper/arch-rootlv /mnt
mkdir -p /mnt/home
mount /dev/mapper/arch-homelv /mnt/home
mkdir -p /mnt/boot
mount /dev/${dev}3 /mnt/boot
mkdir -p /mnt/boot/EFI
mount /dev/${dev}2 /mnt/boot/EFI

pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
