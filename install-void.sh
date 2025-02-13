#!/bin/sh

touch /root/void-install/install.log
{
######################
## Script variables ##
######################

# Set variables
MAJOR_VERSION=$(uname -r | awk -F '.' '{print $1}')
MINOR_VERSION=$(uname -r | awk -F '.' '{print $2}')
VERSION=${MAJOR_VERSION}.${MINOR_VERSION}
DISK="nvme0n1"
EFI_SIZE="1024MiB"
PKG_BASE="base-system binutils bluez bolt connman-gtk chrony cryptsetup dbus dhcpcd efibootmgr iptables libavcodec libspa-bluetooth libva-utils mesa-dri mesa-vaapi mesa-vdpau opendoas pipewire seatd sof-firmware sbctl sbsigntool systemd-boot-efistub tlp tpm2-tools vulkan-loader wireplumber"
PKG_APPS="audacity autotiling base-devel blueman btop curl evince ffmpeg firefox flatpak foot gimp grim git imv inkscape jq kanshi ldns libreoffice-calc libreoffice-gnome libreoffice-impress libreoffice-writer meson mumble neovim nextcloud-client nnn nodejs nwg-look obs qt6-wayland pavucontrol profanity ripgrep Signal-Desktop slurp starship sound-theme-freedesktop swaybg swayfx swappy swaylock tldr upower Waybar wget wdisplays wireguard-dkms wireguard-tools wl-clipboard wofi xdg-desktop-portal-gtk xdg-desktop-portal-wlr"
PKG_AMD="linux-firmware-amd mesa-vulkan-radeon"
PKG_INTEL="intel-media-driver intel-ucode ipw2100-firmware mesa-vulkan-intel"
LANG="en_US.UTF-8"
HOST="laptop"
FQDN="laptop.cryogence.org"
USER="dbegin"
NET_DEV="eth0"
NET_CIDR="10.10.10.92/24"
NET_GW="10.10.10.1"
NET_DNS1="10.10.10.21"
NET_DNS2="10.10.10.22"

# Install script package requirements
xbps-install -Sfy parted

# Detect CPU type
CPU_VENDOR=$(grep vendor_id /proc/cpuinfo | awk 'NR==1 {print $3}')
if [ "$CPU_VENDOR" = "GenuineIntel" ]; then
  PKG_ALL="$PKG_BASE $PKG_INTEL $PKG_APPS"
elif [ "$CPU_VENDOR" = "AuthenticAMD" ]; then
  PKG_ALL="$PKG_BASE $PKG_AMD $PKG_APPS"
else
  echo "Unspported CPU type: $CPU_VENDOR"
  exit 1
fi

#######################
## Disk partitioning ##
#######################

# Format the boot disk
echo "Formating the disk ${DISK}..."
dd if=/dev/zero of=/dev/${DISK} bs=1M count=100

# Create a new gpt partition table
echo "Creating GPT partition table on ${DISK}..."
parted -s /dev/${DISK} mklabel gpt

# Create efi partition
echo "Creating $EFI_SIZE EFI partition..."
parted -s -a optimal /dev/${DISK} mkpart primary fat32 2048s $EFI_SIZE

# Create root partition
echo "Creating linux partition on rest of free space..."
parted -s -a optimal /dev/${DISK} mkpart primary ext4 $EFI_SIZE 100%

# Set esp on efi partition
echo "Setting esp flag on EFI partition..."
parted -s /dev/${DISK} set 1 esp on

#####################
## Disk encryption ##
#####################

# Encrypt root partition
echo "Encrypt root partition with LUKS2 aes-512..."
cryptsetup --label crypt --type luks2 --cipher aes-xts-plain64 --key-size 256 --hash sha256 --iter-time 1000 --use-random luksFormat /dev/${DISK}p2

# Open encrypted partition
echo "Opening crypt partition..."
cryptsetup open --allow-discards --type luks /dev/${DISK}p2 root

######################
## Filesystem setup ##
######################

# Make filesystems
echo "Creating filesystems..."
mkfs.fat -F 32 -n EFI /dev/${DISK}p1
mkfs.ext4 -L ROOT /dev/mapper/root

# Mounting filesystems
echo "Mounting filesystems..."
mount /dev/mapper/root /mnt
mkdir -p /mnt/efi
mount /dev/${DISK}p1 /mnt/efi
for dir in dev proc sys run; do
  mkdir -p /mnt/${dir}
  mount --rbind --make-rslave /${dir} /mnt/${dir}
done

#########################
## System installation ##
#########################

# Install void and packages
echo "Copying XBPS RSA keys..."
mkdir -p /mnt/var/db/xbps/keys
cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/
echo "Installing Void and necessary packages..."
xbps-install -Sy -R https://repo-fastly.voidlinux.org/current -R https://repo-fastly.voidlinux.org/current/nonfree -r /mnt $PKG_ALL

# Copy etc into new install
echo "Copying etc directory to new install..."
rm -f /mnt/etc/iptables/*
cp -rf ~/void-install/etc /mnt/

# Set root permissions
echo "Setting root permissions..."
chroot /mnt chown root:root /

# Configure locale and language
echo "Configuring locale and language..."
echo "LANG=$LANG" > /mnt/etc/locale.conf
echo "$LANG UTF-8" >> /mnt/etc/default/libc-locales
chroot /mnt xbps-reconfigure -f glibc-locales

# Set hostname
echo "Setting hostname..."
echo $FQDN > /mnt/etc/hostname
echo "127.0.0.1        $FQDN $HOST" >> /mnt/etc/hosts

# Set localtime
echo "Setting localtime..."
chroot /mnt ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

##########################
## System configuration ##
##########################

# Set root password
echo "Set root password..."
passwd -R /mnt root

# Setup primary user
echo "Setting up ${USER}..."
chroot /mnt useradd -m -G wheel,audio,video,cdrom,optical,storage,kvm,input,plugdev,users,xbuilder,bluetooth,_pipewire,_seatd -s /bin/bash $USER
cat <<EOF > /mnt/etc/doas.conf
permit nopass keepenv :wheel

EOF
mkdir -p /mnt/etc/sudoers.d
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" > /mnt/etc/sudoers.d/${USER}
chmod 600 /mnt/etc/sudoers.d/${USER}

# Set primary user password
echo "Set $USER password..."
chroot /mnt passwd $USER

# Enable services
echo "Enabling all necessary services..."
chroot /mnt ln -s /etc/sv/acpid /var/service/
chroot /mnt ln -s /etc/sv/bluetoothd /var/service/
chroot /mnt ln -s /etc/sv/boltd /var/service/
chroot /mnt ln -s /etc/sv/chronyd /var/service/
chroot /mnt ln -s /etc/sv/connmand /var/service/
chroot /mnt ln -s /etc/sv/dbus /var/service/
chroot /mnt ln -s /etc/sv/dhcpcd /var/service/
chroot /mnt ln -s /etc/sv/iptables /var/service/
chroot /mnt ln -s /etc/sv/seatd /var/service/
chroot /mnt ln -s /etc/sv/tlp /var/service/

# Configure static IP template for dhcpd
# Remove pound signs if you want to boot with static IP via dhcpd
echo "Configuring static IP..."
echo "# Static IP for $NET_DEV" >> /mnt/etc/dhcpcd.conf
echo "#interface $NET_DEV" >> /mnt/etc/dhcpcd.conf
echo "#static ip_address=$NET_CIDR" >> /mnt/etc/dhcpcd.conf
echo "#static routers=$NET_GW" >> /mnt/etc/dhcpcd.conf
echo "#static domain_name_servers=$NET_DNS1 $NET_DNS2" >> /mnt/etc/dhcpcd.conf

########################
## Boot configuration ##
########################

# Disable runit from remounting everything
echo "Configuring runit..."
chroot /mnt mv /etc/runit/core-services/03-filesystems.sh{,.bak}

# Set permissions for secureboot keys
echo "Setting permissions for secureboot keys..."
chroot /mnt chattr -i /sys/firmware/efi/efivars/db*
chroot /mnt chattr -i /sys/firmware/efi/efivars/KEK*
chroot /mnt chattr -i /sys/firmware/efi/efivars/PK*

# Prepare secureboot
echo "Preparing secureboot..."
chroot /mnt sbctl create-keys
chroot /mnt sbctl enroll-keys --microsoft

# Find and set crypt partition UUID
LUKS_CRYPT_UUID="$(lsblk -o NAME,UUID | grep ${DISK}p2 | awk '{print $2}')"
ROOT_UUID="$(lsblk -o NAME,UUID | grep root | awk '{print $2}')"

# Create boot key
echo "Creating boot key for LUKS2..."
touch /mnt/boot/crypt.key
chmod 600 /mnt/boot/crypt.key
dd bs=1 count=64 if=/dev/urandom of=/mnt/boot/crypt.key
cryptsetup luksAddKey /dev/${DISK}p2 /mnt/boot/crypt.key

# Add crypttab entries
echo "Adding crypttab entries..."
echo "root UUID=${LUKS_CRYPT_UUID} /boot/crypt.key luks,discard" >> /mnt/etc/crypttab

# Set kernel cmdline for dracut and efibootmgr config
echo "Setting kernel cmdline..."
if [ "$CPU_VENDOR" = "GenuineIntel" ]; then
  echo "kernel_cmdline=\" root=UUID=${ROOT_UUID} iommu=pt intel_iommu=igfx_off net.ifnames=0 ipv6.disable=1 quiet loglevel=3 \"" >> /mnt/etc/dracut.conf.d/void-linux.conf
elif [ "$CPU_VENDOR" = "AuthenticAMD" ]; then
  echo "kernel_cmdline=\" root=UUID=${ROOT_UUID} iommu=pt net.ifnames=0 ipv6.disable=1 quiet loglevel=3 \"" >> /mnt/etc/dracut.conf.d/void-linux.conf
else
  echo "Unspported CPU type: $CPU_VENDOR. Using generic kernel_cmdline"
  echo "kernel_cmdline=\" root=UUID=${ROOT_UUID} net.ifnames=0 ipv6.disable=1 quiet loglevel=3 udev.log_level=3 \"" >> /mnt/etc/dracut.conf.d/void-linux.conf
fi

# Allow srcipts to be executable
echo "Ensure boot scripts are executable..."
chmod 744 /mnt/etc/kernel.d/post-install/*
chmod 744 /mnt/etc/kernel.d/post-remove/*

# Reconfigure XBPS
echo "disabling default mirror..."
echo "#repository=https://repo-default.voidlinux.org/current" > /mnt/usr/share/xbps.d/00-repository-main.conf

echo "Resyncing XBPS to new mirrors..."
chroot /mnt xbps-install -S

echo "Removing uneeded packages..."
chroot /mnt xbps-remove -oO adwaita-icon-theme btrfs-progs f2fs-tools linux-firmware-broadcom linux-firmware-nvidia mdocml sudo void-artwork wifi-firmware xfsprogs amiri-font culmus dejavu-fonts-ttf font-adobe-source-code-pro font-adobe-source-sans-pro-v2 font-adobe-source-serif-pro font-alef font-awesome font-crosextra-caladea-ttf font-crosextra-carlito-ttf font-emoji-one-color font-kacst font-liberation-narrow-ttf font-libertine-graphite-ttf font-reem-kufi-ttf font-sil-gentium-basic font-sil-scheherazade gsfonts liberation-fonts-ttf libreoffice-fonts noto-fonts-ttf noto-fonts-ttf-extra

echo "Generating initramfs, uki, and locale for kernel verison ${VERSION}..."
chroot /mnt xbps-reconfigure -f linux${VERSION}

VOID_DONE="
##############################################
     Void Linux ${VERSION} install has finished!
Please reboot into BIOS and enable secureboot!
##############################################
"
echo "${VOID_DONE}"
} 2>&1 | tee /root/void-install/install.log
