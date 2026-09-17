# ft-game-optimizer

[English](README_EN.md) | **Bahasa Indonesia**

Optimizer game/desktop fullscreen-aware untuk setup Linux/X11/XFCE, dengan integrasi Fatix, custom Mesa/Crocus, dan background pausing yang aman untuk Alt+Tab.

> Dibuat oleh **ft_aska.90**
>
> Repository ini berisi rekonstruksi baseline terbaru **Fatix Game Mode / `fatix-game`** yang digunakan pada mesin pembuat.

## Lingkungan Pengembangan / Pengujian

- Laptop: **Toshiba Satellite L735 (PSK0AL-010004)**
- CPU: **Intel Core i3-2350M @ 2.30 GHz**
- GPU: **Intel HD Graphics 3000 / Sandy Bridge GT2**
- GPU PCI ID: **8086:0116**
- RAM: **3.76 GiB**
- OS: **CachyOS x86_64**
- Kernel pengembangan: **Linux 7.1.8-1-cachyos**
- Desktop Environment: **Xfce 4.20**
- Window Manager: **Xfwm4**
- Display Server: **X11**
- Graphics stack: **Mesa 26.1.6 / Crocus / i915**

## Peringatan Kompatibilitas

Project ini dapat menghentikan service, pause proses GUI, mengubah compositor sementara, dan menjalankan command melalui custom Mesa environment. **Jangan menjalankannya sembarangan pada perangkat atau desktop stack yang berbeda.**

Project boleh dicoba jika environment kamu sama atau cukup kompatibel dan kamu sudah membaca script/config yang akan digunakan.

## Fitur Fatix Game Mode

- menghentikan `fatix.service`, `fatix-rust.service`, `fatix_rust.service`, serta proses `fatix` / `fatix_rust` bila aktif;
- menghentikan live wallpaper `livew` bila aktif;
- membiarkan **btop/htop** tetap berjalan;
- menyimpan lalu menonaktifkan compositor Xfwm4 selama game jika dikonfigurasi;
- menjalankan game melalui `meson devenv -C ~/fatix-crocus/build` jika custom Mesa build tersedia;
- memakai `FATIX_PROFILE=balanced`;
- memakai `FATIX_SIMD_HEURISTIC=1`;
- memakai `MESA_LOADER_DRIVER_OVERRIDE=crocus`;
- memakai `vblank_mode=0`;
- memonitor fullscreen setiap **0.25 detik**;
- hanya melakukan `SIGSTOP` ke aplikasi GUI non-protected ketika active window benar-benar fullscreen;
- langsung melakukan `SIGCONT` saat keluar fullscreen / Alt+Tab;
- melindungi Xfce, Xorg, panel, audio, session/input services, Steam/Proton/Wine/Gamescope/GameMode, terminal, SSH, btop/htop, game process tree, dan active fullscreen PID;
- memulihkan compositor, Fatix, live wallpaper, dan proses yang dipause setelah game selesai.

Detail: [`docs/BEHAVIOR.md`](docs/BEHAVIOR.md).

## Custom Mesa

Default path:

```text
MESA_DIR=$HOME/fatix-crocus/mesa
BUILD_DIR=$HOME/fatix-crocus/build
```

Jika build tersedia:

```bash
meson devenv -C "$BUILD_DIR" COMMAND [ARG...]
```

Jika tidak tersedia, command tetap dapat dijalankan tanpa custom Mesa environment.

## Config

Template:

```text
config/fatix-game.conf
```

Installer menaruh konfigurasi lokal di:

```text
~/.config/fatix-game/config
```

Setting utama:

```bash
FATIX_PROFILE="balanced"
FATIX_SIMD_HEURISTIC="1"
MESA_LOADER_DRIVER_OVERRIDE="crocus"
vblank_mode="0"
FATIX_GAME_POLL_INTERVAL="0.25"
FATIX_GAME_PAUSE_GUI="1"
FATIX_GAME_DISABLE_COMPOSITOR="1"
FATIX_GAME_STOP_FATIX="1"
FATIX_GAME_STOP_LIVEW="1"
```

## Install

```bash
git clone https://github.com/ftaska90/ft-game-optimizer.git
cd ft-game-optimizer
chmod +x install.sh
./install.sh
```

Installer memasang:

```text
~/.local/bin/fatix-game
~/.local/bin/sober-fatix
~/.local/bin/fatix-game-check
~/.config/fatix-game/config
```

## Pemakaian

```bash
fatix-game COMMAND [ARG...]
```

Contoh:

```bash
fatix-game glmark2
fatix-game ./game
```

Steam launch option:

```text
fatix-game %command%
```

## Sober

```bash
sober-fatix
```

Launcher ini memakai `FLATPAK_GL_DRIVERS=fatix` lalu menjalankan Sober melalui Fatix Game Mode.

## Struktur Repository

```text
config/
  fatix-game.conf
scripts/
  fatix-game
  sober-fatix
  check-environment
docs/
  BEHAVIOR.md
install.sh
LICENSE
NOTICE
```

## Pembuat

Dibuat oleh **ft_aska.90**.

Copyright (c) 2026 ft_aska.90.

## Lisensi

Dilindungi oleh **MIT License**. Lihat [`LICENSE`](LICENSE).
