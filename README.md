# VeilOS

An Arch-based Linux distribution built around **Veil**, a custom Wayland
terminal display compositor, with its own tooling, greeter, and boot
experience baked in from install.

## What's in it

- **Veil** — the terminal display compositor (`veil-compositor` in Rust/Smithay,
  `veil-render` in Zig, `veil-config` in Rust/mlua, `veil-cli` in Rust).
  Bare-TTY and windowed modes, dwindle layout, Lua keybinds.
- **Woven** — Wayland workspace daemon with a Lua plugin API, control panel,
  bar, and AI workspace namer.
- **VeilLogin** — the default login manager. Slint-based, themeable, session
  picker, man page included.
- **Machina** — TUI file manager (Rust/ratatui).
- **GlassPad** — scratchpad tool.
- A Plymouth boot splash and system branding (`os-release`, `fastfetch`,
  `/etc/issue`, `/etc/motd`) so it looks and feels like VeilOS from the
  moment the machine powers on, not stock Arch with extra packages.
## Downloading

Find the iso at (Downloader)[https://archive.org/details/veilos-2026.08.15-x86_64] and run that or use the torrent. This is the OFFICIAL current iso. Anything else is either outdated or NOT MINE. 

## Installing

Boot the ISO and run the installer (`installer.sh`) from the live
environment. It's a graphical (YAD) wizard — set your disk, filesystem,
bootloader, swap, desktop, and login manager, confirm, and it handles the
rest (partitioning, base system, bootloader, branding, onboard tools).

See the installer's own README for what it actually does under the hood.

## Package sources

VeilOS pulls `machina`, `yay-bin`, and `glasspad` from its own `[veilos]`
pacman repo (configured in `pacman.conf`) rather than building anything from
the AUR at install time. `yay` is included so you can pull additional AUR
packages yourself after install.

## Desktops supported by the installer

`plasma`, `gnome`, `xfce`, `i3`, `sway` (+ Woven), and `veil` (the native
compositor). Login manager can be the desktop's usual default, an explicit
choice (sddm/gdm/lightdm), `velogin`, or a custom command you provide.

## Bootloaders supported

`limine` (default), `grub`, `systemd-boot` (UEFI only). All three get a
Plymouth splash if the boot theme is present on the ISO.

## License / contributing
**CC 1.0 UNIVERSAL**

When contributing, or using AI please review the work even if it means using another AI to do it. Proofread pull requests, check over code for OBVIOUS bad signs, and most importantly. Test it. I will not accept anything without thorough **MANUAL** testing done on it.
