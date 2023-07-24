#!/bin/sh
# chrootした後に入る。
pacman -Syyu

# timezone
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ハードウェアクロック
hwclock --systohc

# locale
sed -i -e 's/#ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen

# locale-gen
echo LANG=ja_JP.UTF-8 > /etc/locale.conf
echo KEYMAP=jp106 > /etc/vconsole.conf

# hostname
echo isksss-arch > /etc/hostname

# hosts
echo "127.0.0.1    localhost" >> /etc/hosts
echo "::1          localhost" >> /etc/hosts

# network
pacman -S networkmanager --noconfirm
systemctl start NetworkManager
systemctl enable NetworkManager

# bootloader
pacman -S grub efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S --noconfirm \
    sudo \
    git \
    zsh \
    go

sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
echo -e "password\npassword\n" | passwd

useradd -m -g users -G wheel -s /bin/zsh isksss
echo -e "password\npassword\n" | passwd isksss

# yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
