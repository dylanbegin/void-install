# ![logo](https://docs.voidlinux.org/favicon.png) Overview
The goal of this automation is to install Void Linux on a laptop. This setup is using a very minimal and secure install with the following goals:
1. UEFI system with Secure Boot.
1. Full disk encryption with LUKS2.
1. Partitioned as below:
  1. 1024MiB /efi efi partition.
  1. Rest / root parition.
  1. No swap (not required for sleep).
1. Void Linux x86 minimal install.
1. Swayfx windows manager.
> [!TIP]
> If you want to mount an NFS share to grab any other files you may want to include in your install: `sudo mount -t nfs -o vers=4 <ip>:/path /mount/path`

# Pre Install
## Prepair Live USB
1. Ensure the USB is not mounted with `sudo umount /dev/sdX`.
1. Write the void image to the USB with `sudo dd bs=4M if=/path/to/void.iso of=/dev/sdX`

## Prepare UEFI
Before running the `install-void.sh` script, there are a few thing that need to be setup first.
1. Enable TPM.
1. Set BIOS password.
1. Boot into BIOS and set secureboot into setup mode.
  1. DELETE all keys
  1. ALLOW microsoft keys (optional)
  1. RESET to setup mode
  1. TURN OFF secureboot (will enable post install)
1. Set a BIOS password (require for both entering bios and boot menu).
1. Set boot order to DISK,USB. Remove all other options.
1. Save and reboot into live install.
> [!WARNING]
> Don't forget to save all passwords to your password manager!

## Running The Install
1. Boot into live install.
1. Login with `root` password `voidlinux`.
1. Clone this repo.
  1. Install git `xbps-install git`.
  1. Clone repo `git clone https://github.com/dylanbegin/void-install.git`.
1. Adujst any variables in the script `install-void.sh` you need.
1. Set the script as executable with `chmod +x install-void.sh`
1. Run the script with `./install-void.sh`
1. Follow all propmts and reboot when it's done.

# Post Install
Once the install is completed remove the USB and reboot back into BIOS.
1. Enable secureboot.
1. Remove USB option from boot menu.
1. Save and reboot. Then login to Void.

## Install Flatpak Suite
Install the main repo.
```sh
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
Then install any needed apps. For example, I use:
```sh
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub com.brave.Browser
flatpak install flathub com.bitwarden.desktop
flatpak install flathub dev.vencord.Vesktop
flatpak install flathub com.jgraph.drawio.desktop
flatpak install flathub com.moonlight_stream.Moonlight
flatpak install flathub com.slack.Slack
```
[!NOTE]
> At this point you are pretty much done with the install. Anything below is my own customizations and dot files, but I'm sharing them here too! Feel free to use whatever you want!

## Theming
Theming in Linux sucks... a lot. And it sucks even more whithout a DE. The `~/.local/share/` folder already comes with several, fonts, icons/cursors, and themes installed. Below is a general guide on how to unify our theme. Also check out the theming section on the Arch wiki for more information [wiki.archlinux.com](https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications).
1. Setup GTk3, icon, and font with `nwg-look`.
1. Copy `gtk-4.0` folder from `~/.local/share/themes/<theme>/` into `~/.config/`.
1. QT...fuck this shit. (TBD)
1. Sync flatpak theming by adding the following lines into the `Other Files` globally:
  ```shell
  ~/.themes:ro
  ~/.config/gtk-3.0:ro
  ~/.config/gtk-4.0:ro
  ~/.config/xsettingsd:ro
  ~/.local/share/themes:ro
  ~/.local/share/icons:ro
  ```
1. Link flatpak environment variables globally:
  ```shell
  GTK_THEME=<theme-name>
  ICON_THEME=<icon-name>
  ```

### Current theming table
(TBD)
| Name                                                    | Type    |
| ----------------------------------------------------- | ---------- |
| [Nerd Fonts](https://www.nerdfonts.com/font-downloads) | Fonts     |

## Cleanup packages
You can cleanup all uneeded packeges with the command below (adjust as needed):
```sh
doas xbps-remove -oO adwaita-icon-theme btrfs-progs f2fs-tools linux-firmware-broadcom linux-firmware-nvidia mdocml sudo void-artwork wifi-firmware xfsprogs amiri-font culmus dejavu-fonts-ttf font-adobe-source-code-pro font-adobe-source-sans-pro-v2 font-adobe-source-serif-pro font-alef font-awesome font-crosextra-caladea-ttf font-crosextra-carlito-ttf font-emoji-one-color font-kacst font-liberation-narrow-ttf font-libertine-graphite-ttf font-reem-kufi-ttf font-sil-gentium-basic font-sil-scheherazade gsfonts liberation-fonts-ttf libreoffice-fonts noto-fonts-ttf noto-fonts-ttf-extra
```

## Bonus Extra Stuff
Below is some early testing stuff I've been messing around with using DWL. This doesn't really work but might help some others using DWL??

### Build Packages Configuration
1. In order to build from source you will need to install the following packages:
   ```sh
   doas xbps-install base-devel cairo-devel clang fcft-devel gtk+-devel gtk+3-devel gtk4-devel gtk-layer-shell-devel meson ninja pango-devel wayland-scanner++ wlroots-devel
   ```
1. Additionaly, if you need rust, you will want to install the nightly toolchain of rust:
   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
   1. Customize the install by selecting `2` and on the toolchain method enter `nightly`.
   1. To uninstall use: `rustup self uninstall`
< These packages can be removed once all builds are complete.
{is.info}

### DWL WM
dwl information: [github.com](https://github.com/djpohly/dwl/).
1. Install dependancy packages: `doas xbps-install cairo pango wayland wayland-protocols wlroots xorg-server-xwayland`
1. Make sure the following repo's are in the `~/build` folder:
   1. dwl: `https://github.com/djpohly/dwl.git`
   1. dwlb: `https://github.com/kolunmi/dwlb.git`
   1. someblock: `https://git.sr.ht/~raphi/someblocks`
   1. afetch: `https://github.com/13-CF/afetch.git`
   1. nnn: `https://github.com/jarun/nnn.git`
1. Build apps: `make` then `make clean install` in each directory (`dwl`, `dwlb`, and `somebar` will require `doas`).
   1. Build `nnn` with `make O_NERD=1`
1. All patches should already be applied, but if you added more in the furture, below is a general guide:
   1. Remove `config.h`: `rm -f config.h`
   1. Apply patch with git: `git apply -3 patches/{patch-name}.diff`
      1. Or apply patch with `patch`: `patch -p1 < patches/{patch-name}.diff`
      1. Debug with: `vi -p {file.rej} {file.c}`
      1. Now check the config files: `vi -d config.def.h config.h`
   1. Remove debug file and make: `rm -f *.orig *.rej` then `make`
   1. Recompile app: `doas make clean install`
1. You can unpatch with: `git apply -R patches/{patch-name}.diff`

If you are using eww here are some tips:
1. Clone eww in `~/build` folder: `git clone https://github.com/elkowar/eww`
1. Build eww: `cargo build --release --no-default-features --features=wayland`
1. Run eww: `cd target/release` then `chmod +x ./eww`
1. Link to bin: `doas ln -s ~/build/eww/target/release/eww /usr/local/bin/`
1. Test eww with: `eww daemon` then `eww -c ~/.config/eww/bar/ open bar`
1. Show logs: `eww -c ~/.config/eww/bar logs`

# References
https://wiki.archlinux.org/title/Dracut
https://wiki.archlinux.org/title/Dm-crypt/System_configuration
https://wiki.archlinux.org/title/EFISTUB
https://wiki.archlinux.org/title/Trusted_Platform_Module
https://wiki.gentoo.org/wiki/EFI_stub
https://github.com/olivier-mauras/void-luks-lvm-installer
https://github.com/NetBeholder/VoidLinux-installation-guide
https://github.com/MeganerdNL/uki-automation-dracut
https://gist.github.com/dko1905/7c9ce651418e01f7838329dd402e5529
https://gist.github.com/Dko1905/dbb88d092aa973a8ba244eb42c5dd6a6
https://practicalparanoid.com/linux/encrypted-void-linux-musl-install-via-cli/
https://mth.st/blog/void-efistub/
https://www.redhat.com/sysadmin/disk-encryption-luks

And some additional reading material around TPM/SB security challenges.
https://en.wikipedia.org/wiki/Cold_boot_attack
https://pulsesecurity.co.nz/articles/TPM-sniffing
https://pulsesecurity.co.nz/advisories/tpm-luks-bypass
https://security.stackexchange.com/questions/252391/understanding-tpm-pcrs-pcr-banks-indexes-and-their-relations
https://pawitp.medium.com/the-correct-way-to-use-secure-boot-with-linux-a0421796eade
https://techjungle.gitlab.io/post/binding_luks_with_tpm/
https://www.tevora.com/threat-blog/configuring-secure-boot-tpm-2/
