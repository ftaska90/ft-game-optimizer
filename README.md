# ft-game-optimizer

Game/desktop optimization project for the author's Linux setup.

> Created by **ft_aska.90**
>
> This repository contains the reconstructed latest **Fatix Game Mode / `fatix-game`** baseline used on the author's machine.

## Development / Tested Environment

Project ini dibuat dan diuji terutama pada lingkungan berikut:

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
- Graphics stack yang dipakai saat pengembangan: **Mesa 26.1.6 / Crocus / i915**

## Compatibility warning

Project ini dibuat berdasarkan environment di atas dan dapat berisi optimasi yang spesifik terhadap hardware, Xfce/X11, service, driver, path, atau konfigurasi sistem tersebut.

**Jangan menjalankan script optimasi secara sembarangan pada perangkat yang berbeda.** Project boleh dicoba jika hardware dan software stack kamu sama atau cukup kompatibel dan kamu sudah memeriksa apa yang akan diubah/dihentikan oleh script sebelum menjalankannya.

Perbedaan distro, DE, Wayland/X11, GPU, driver, service systemd, atau versi kernel dapat menyebabkan fitur tidak bekerja, menurunkan stabilitas, atau menghasilkan perilaku yang berbeda dari environment pengembangan.

Sebelum mencoba, jalankan:

```bash
fatix-game-check
```

atau langsung dari repository:

```bash
./scripts/check-environment
```

## Fatix Game Mode

Script utama: [`scripts/fatix-game`](scripts/fatix-game).

Baseline ini melakukan hal berikut:

- menghentikan `fatix.service`, `fatix-rust.service`, `fatix_rust.service`, serta proses `fatix` / `fatix_rust` bila aktif;
- menghentikan live wallpaper `livew` bila terdeteksi aktif;
- membiarkan **btop/htop** tetap hidup;
- menyimpan dan menonaktifkan compositor Xfwm4 selama game jika setting tersebut aktif;
- menjalankan game dengan custom Mesa/Crocus melalui `meson devenv -C ~/fatix-crocus/build` jika build tersebut tersedia;
- memakai `FATIX_PROFILE=balanced`;
- memakai `FATIX_SIMD_HEURISTIC=1`;
- memakai `MESA_LOADER_DRIVER_OVERRIDE=crocus`;
- memakai `vblank_mode=0`;
- memonitor fullscreen melalui `xprop` setiap **0.25 detik**;
- hanya melakukan `SIGSTOP` pada aplikasi GUI non-protected ketika active window benar-benar fullscreen;
- langsung melakukan `SIGCONT` ketika keluar fullscreen / Alt+Tab;
- melindungi Xfce, Xorg, panel, audio, input/session services, Steam/Proton/Wine/Gamescope/GameMode, terminal, SSH, btop/htop, process tree game, dan active fullscreen PID;
- memulihkan compositor, Fatix, live wallpaper, dan semua PID yang dipause setelah game selesai.

Detail mekanismenya ada di [`docs/BEHAVIOR.md`](docs/BEHAVIOR.md).

## Custom Mesa path

Default yang digunakan:

```text
MESA_DIR=$HOME/fatix-crocus/mesa
BUILD_DIR=$HOME/fatix-crocus/build
```

Jika `BUILD_DIR` tersedia, command dijalankan melalui:

```bash
meson devenv -C "$BUILD_DIR" COMMAND [ARG...]
```

Jika tidak tersedia, `fatix-game` tetap bisa menjalankan command secara normal tanpa custom Mesa environment.

## Config

Template konfigurasi:

```text
config/fatix-game.conf
```

Installer menaruhnya di:

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

Tambahkan proses yang tidak boleh dipause melalui:

```bash
FATIX_GAME_EXTRA_PROTECTED='discord|vesktop'
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

Config lokal yang sudah ada **tidak ditimpa** saat menjalankan installer lagi.

## Usage

Native command/game:

```bash
fatix-game COMMAND [ARG...]
```

Contoh:

```bash
fatix-game glmark2
fatix-game ./game
```

Untuk game Steam, gunakan sebagai launch wrapper:

```text
fatix-game %command%
```

Jangan menjalankan seluruh Steam client lewat optimizer jika targetnya hanya satu game; wrapper `%command%` membuat lifecycle game lebih mudah dilacak dan dipulihkan.

## Sober

Launcher khusus tersedia sebagai:

```bash
sober-fatix
```

Launcher ini menggunakan:

```text
FLATPAK_GL_DRIVERS=fatix
```

kemudian menjalankan:

```bash
fatix-game flatpak run org.vinegarhq.Sober
```

Ini mengasumsikan custom Flatpak GL driver bernama `fatix` sudah tersedia di sistem.

## Repository layout

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

## Author

Created by **ft_aska.90**.

Copyright (c) 2026 ft_aska.90.

## License

Licensed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
