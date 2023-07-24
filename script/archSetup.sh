#!/bin/sh

# 初期設定
loadkeys jp106
timedatectl set-ntp true

# パーティション作成
parted -s /dev/sda mklabel gpt
parted -s /dev/sda mkpart ESP 0% 512MiB
parted -s /dev/sda set 1 esp on
parted -s /dev/sda mkpart primary ext4 512MiB 100%
# フォーマット
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# マウント
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# arch インストール
pacstrap /mnt base base-devel linux linux-firmware

# fstab 作成
genfstab -U /mnt >> /mnt/etc/fstab

cp archSetup2.sh /mnt/archSetup2.sh
