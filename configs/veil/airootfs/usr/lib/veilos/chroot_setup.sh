#!/usr/bin/env bash
# chroot_setup.sh — VeilOS chroot setup
# Called from within arch-chroot environment
# Usage: arch-chroot /mnt /usr/lib/veilos/chroot_setup.sh <bootloader> <boot_type> <disk>

set -e

BOOTLOADER="$1"
BOOT_TYPE="$2"
DISK="$3"

[[ -n "$BOOTLOADER" ]] || { echo "Error: BOOTLOADER not set"; exit 1; }
[[ -n "$BOOT_TYPE" ]] || { echo "Error: BOOT_TYPE not set"; exit 1; }
[[ -n "$DISK" ]] || { echo "Error: DISK not set"; exit 1; }

echo "[chroot] Installing $BOOTLOADER ($BOOT_TYPE mode)"

case "$BOOTLOADER" in
grub)
  echo "[chroot] Installing GRUB..."
  if [[ "$BOOT_TYPE" == "efi" ]]; then
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=VeilOS || exit 1
  else
    grub-install --target=i386-pc "$DISK" || exit 1
  fi
  grub-mkconfig -o /boot/grub/grub.cfg || exit 1
  echo "[chroot] GRUB installed"
  ;;

systemd-boot)
  if [[ "$BOOT_TYPE" != "efi" ]]; then
    echo "Error: systemd-boot requires UEFI"
    exit 1
  fi
  echo "[chroot] Installing systemd-boot..."
  bootctl install || exit 1
  mkdir -p /boot/loader/entries
  cat > /boot/loader/entries/veilos.conf << 'EOF'
title VeilOS
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=LABEL=root rw
EOF
  echo "[chroot] systemd-boot installed"
  ;;

limine)
  echo "[chroot] Installing Limine..."
  mkdir -p /boot/limine /boot/EFI/BOOT
  
  if [[ -f /usr/share/limine/BOOTX64.EFI ]]; then
    cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/
  fi
  
  if [[ -f /usr/share/limine/limine-bios.sys ]]; then
    cp /usr/share/limine/limine-bios.sys /boot/limine/
  fi
  
  cat > /boot/limine/limine.cfg << 'EOF'
timeout: 5
default_entry: 0

/veilos
    protocol: linux
    path: boot():/vmlinuz-linux
    cmdline: root=LABEL=root rw quiet
    module_path: boot():/initramfs-linux.img
EOF
  
  if [[ "$BOOT_TYPE" == "bios" ]]; then
    if command -v limine-deploy &>/dev/null; then
      limine-deploy "$DISK" 2>/dev/null || echo "[chroot] limine-deploy failed (non-critical)"
    fi
  fi
  echo "[chroot] Limine installed"
  ;;

*)
  echo "Error: Unknown bootloader: $BOOTLOADER"
  exit 1
  ;;
esac

echo "[chroot] Bootloader setup complete"
