#!/bin/sh
# An updated arch install command list w/ btrfs

##################################################
#                                                #
# 		Base Installation                #
#                                                #
##################################################

# Set root passwd to allow ssh
passwd # my default is pass

# Enter tmux session for using multiple terminals
tmux new-session -s archinstall

# Check for UEFI, if this command prints 64 OR 32 UEFI is active
cat /sys/firmware/efi/fw_platform_size

# Check internet reachability
ping -c 3 archlinux.org

# Check if NTP is active
timedatectl

# If inactive run
timedatectl set-ntp true

# View the current partitioning setup
fdisk -l

# Create partitions
fdisk /dev/$YOUR_DISK_LABEL
g
n
[Default]
[Default]
+1G
n
[Default]
[Default]
[Default]
t
1
1
p # verify partitions
w

# Format file systems
mkfs.fat -F 32 /dev/$YOUR_DISK_LABEL
mkfs.btrfs /dev/$YOUR_DISK_LABEL

# Mount your created btrfs data partition
mount /dev/$YOUR_DISK_LABEL /mnt

# Create following btrfs subvols
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@swap
btrfs subvolume create /mnt/@var-cache
btrfs subvolume create /mnt/@var-log
btrfs subvolume create /mnt/@var-tmp

# List btrfs subvolumes
btrfs subvolume list /mnt
# OR to get just subvolume IDs for mounting
btrfs subvolume list /mnt | awk '{print $1,$2,$NF}'

# umount root partition to re-mount subvol(s)
umount -l /mnt

# In future consider "autodefrag" mount opt!!

# Mounting root subvol by ID 
mount -o noatime,compress=zstd,subvolid=$YOUR_ROOT_SUBVOL_ID /dev/$YOUR_DISK_LABEL /mnt

# Making DIRs for other subvols
mkdir -p /mnt/{efi,home,.snapshots,swap,var/cache,var/log,var/tmp,mnt,mnt/top-ro}

# Mounting other subvol by ID 
mount -o noatime,compress=zstd,subvolid=$YOUR_HOME_SUBVOL_ID /dev/$YOUR_DISK_LABEL /mnt/home
mount -o noatime,compress=zstd,subvolid=$YOUR_SNAPSHOTS_SUBVOL_ID /dev/$YOUR_DISK_LABEL /mnt/.snapshots
mount -o noatime,subvolid=$YOUR_SWAP_SUBVOL_ID /dev/$YOUR_DISK_LABEL /mnt/swap
mount -o noatime,compress=zstd,subvolid=$YOUR_VAR_CACHE_SUBVOL_ID /dev/$YOUR_DISK_LABEL /mnt/var/cache
mount -o noatime,compress=zstd,subvolid=$YOUR_VAR_LOG_SUBVOL_ID /dev/$YOUR_DISK_LABEL /mnt/var/log
mount -o noatime,compress=zstd,subvolid=$YOUR_VAR_TMP_SUBVOL_ID /dev/$YOUR_DISK_LABEL /mnt/var/tmp
mount -o ro,noatime /dev/$YOUR_DISK_LABEL /mnt/mnt/top-ro

# Mount boot partition
mount /dev/$YOUR_BOOT_DISK_LABEL /mnt/efi

# Make btrfs swap file
btrfs filesystem mkswapfile --size 4G --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile

# Pull good mirrorlist(s)
pacman -Sy
reflector --country US --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Download initial packages; minimal list
pacstrap /mnt base linux linux-firmware vim man-db sudo grub efibootmgr dosfstools os-prober mtools networkmanager virtualbox-guest-utils base-devel openssh python btrfs-progs
# OR
pacstrap /mnt - < file-with-package-names.txt

# Generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab
systemctl daemon-reload

# Context switch into new system
arch-chroot /mnt

# Set timezone
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

# Sync system time to hardware clock
hwclock --systohc

# Generate locale
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8 /' /etc/locale.gen
locale-gen

# Create locale config file to set $LANG
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set your hostname
echo "$FOO" > /etc/hostname

# Create hosts file w/ following contents:
# 127.0.0.1 localhost
# ::1 localhost
# 127.0.1.1 $FOO
vim /etc/hosts

# Update root passwd of mounted machine
passwd

# Create new system user; My default user & pass is "vmuser"
useradd -m -d /home/$USERNAME -G wheel,audio,video,optical,storage "$USERNAME"
passwd "$USERNAME"

# Setup grub cfg if desired
vim /etc/default/grub

# Make grub install
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id="Arch Linux VM" --recheck

# Generate grub cfg
grub-mkconfig -o /boot/grub/grub.cfg

# Download guest utils if vbox machine
pacman -S virtualbox-guest-utils

# Enable essential services
systemctl enable NetworkManager sshd vboxservice ly@tty2.service

# Set up sudoers file; uncomment wheel section
EDITOR=vim visudo

# Exit chroot
exit

# umount all mounted subvols & partitions
umount -Rl /mnt

# reboot and your off to the races
reboot

# Install yay AUR helper
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si 

# Install yay package list
yay -S - < yay-packages-install-list.txt

# Create subvol from .cache & delete old
mv ~/.cache ~/.cache-old
btrfs subvolume create .cache
cp -ra ~/.cache-old ~/.cache
rm -r ~/.cache-old

# Create snapshot DIRs in /.snapshots
sudo mkdir /.snapshots/{ROOT-snaps,HOME-snaps}

# Install grub-btrfsd
sudo pacman -S grub-btrfs inotify-tools

# Edit grub-btrfsd service file
# ExecStart=/usr/bin/grub-btrfsd --syslog /your/root/snapshots/dir
sudo systemctl edit --full grub-btrfsd

# Enable grub-btrfsd service file
sudo systemctl enable --now grub-btrfsd

# Clone backker
# Sign into bitwarren and create / add ssh keys
git clone git@github.com:BitWarren/backker-backup.git

# Install backker
sudo cp -r backker-backup /usr/local/sbin/
sudo -i
cd /usr/local/sbin/backker-backup/
cp /systemd/* /etc/systemd/system/
systemctl daemon-reload

# Configure backer service with target subvols
# ExecStart=bash -c '/usr/local/sbin/backker-backup/backker.sh "/path/to/source/subvolume" "/path/to/snapshot/storage" "SNAPSHOT-NAME" | tee -a /var/log/backker.log'
sudo systemctl edit --full backker.service

# Test backker.service
systemctl start backker.service
journalctl -xe
tail -n 50 -f /var/log/backker.log

# Start backker.timer
systemctl enable backker.timer

# Clone dotfiles
git clone git@github.com:BitWarren/dotfiles.git

# Install dotfiles how you wish...
# Reboot and test...


##################################################
#                                                #
# 		Setting up snapper               #
#                                                #
##################################################

# Install snapper, grub-btrfs, and snapper-rollback
# Install yay if needed
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si 
sudo pacman -S snapper grub-btrfs inotify-tools
yay -Sy snapper-rollback

# Snapper will automatically create a subvol and folder called /.snapshots
# We have already created this, so to remedy we umount /.snapshots and 
# rmdir /.snapshots before generating the snapper config.
sudo umount -l /.snapshots

# Now generate a snapper config
sudo snapper -c root create-config /
sudo snapper -c home create-config /

# Delete /.snapshots dir
rmdir /.snapshots

# Delete subvol snapper generated
btrfs subvolume delete .snapshots --subvolid $YOUR_SNAPSHOTS_SUBVOL_ID

# Recreate /.snapshots DIR & remount fstab mounts
sudo mkdir /.snapshots
sudo mount -a

# Make /.snapshots DIR RWX and RX for group
sudo chmod 750 /.snapshots

# Create /home/$USER/.snapshots dir
# This is not automounted, but manually
# mounted via snapper for data recovery.
mkdir /home/$USER/.snapshots
sudo chmod 750 /.snapshots

# Snapper .snapshots DIRs must be owned
# by root but can share perm w/ a group.
groupadd snapper
usermod -aG snapper "$USER"
chown root:snapper /home/$USER/.snapshots

# Edit snapper config to allow snapper 
# group to manage snapper snapshots
# AND make other timer customizations.
vim /etc/snapper/configs/root
vim /etc/snapper/configs/home
/ALLOW_GROUP # search in vim

# Configure snapper-rollback.conf
vim /etc/snapper-rollback.conf
# Add the below line to the bottom:
# dev = /dev/sda2

# Make dir for rollback to mount to
# during snapper-rollback script run.
sudo mkdir /btrfsroot

# Enable snapper service(s)
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
sudo systemctl enable fstrim.timer

# Enable grub-btrfs
sudo /etc/grub.d/41_snapshots-btrfs
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl enable --now grub-btrfsd 

# Create a base snapper snapshot manually
snapper create -b "baseline snap"
snapper -c home create -b "baseline snap"

##################################################
#                                                #
# 		Setting up btrbk                 #
#                                                #
##################################################

# WIP from here on

# Install btrbk and mbuffer
sudo pacman -Sy borg
sudo yay -Sy snapborg


