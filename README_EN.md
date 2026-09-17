# ft-game-optimizer

**English** | [Bahasa Indonesia](README_ID.md)

A fullscreen-aware game/desktop optimizer for Linux/X11/XFCE with Fatix integration, custom Mesa/Crocus support, and Alt+Tab-safe background pausing.

> Created by **ft_aska.90**
>
> This repository contains a reconstruction of the latest **Fatix Game Mode / `fatix-game`** baseline used on the author's machine.

## Development / Tested Environment

- Laptop: **Toshiba Satellite L735 (PSK0AL-010004)**
- CPU: **Intel Core i3-2350M @ 2.30 GHz**
- GPU: **Intel HD Graphics 3000 / Sandy Bridge GT2**
- GPU PCI ID: **8086:0116**
- RAM: **3.76 GiB**
- OS: **CachyOS x86_64**
- Development kernel: **Linux 7.1.8-1-cachyos**
- Desktop Environment: **Xfce 4.20**
- Window Manager: **Xfwm4**
- Display Server: **X11**
- Graphics stack: **Mesa 26.1.6 / Crocus / i915**

## Compatibility Warning

This project may stop user services, pause GUI processes, temporarily change compositor state, and launch commands through a custom Mesa environment. **Do not run it blindly on a different device or desktop stack.**

Only try it when your environment is the same or sufficiently compatible and you have reviewed the scripts/configuration first.

## Fatix Game Mode Features

- stops `fatix.service`, `fatix-rust.service`, `fatix_rust.service`, and `fatix` / `fatix_rust` processes when active;
- stops the `livew` wallpaper when active;
- keeps **btop/htop** running;
- saves and temporarily disables the Xfwm4 compositor when configured;
- launches games through `meson devenv -C ~/fatix-crocus/build` when the custom Mesa build is available;
- uses `FATIX_PROFILE=balanced`;
- uses `FATIX_SIMD_HEURISTIC=1`;
- uses `MESA_LOADER_DRIVER_OVERRIDE=crocus`;
- uses `vblank_mode=0`;
- checks fullscreen state every **0.25 seconds**;
- only sends `SIGSTOP` to non-protected GUI applications while the active window is actually fullscreen;
- immediately sends `SIGCONT` after leaving fullscreen / Alt+Tab;
- protects Xfce, Xorg, the panel, audio, session/input services, Steam/Proton/Wine/Gamescope/GameMode, terminals, SSH, btop/htop, the game process tree, and the active fullscreen PID;
- restores compositor state, Fatix, live wallpaper, and paused processes after the game exits.

Details: [`docs/BEHAVIOR.md`](docs/BEHAVIOR.md).

## Custom Mesa

Default paths:

```text
MESA_DIR=$HOME/fatix-crocus/mesa
BUILD_DIR=$HOME/fatix-crocus/build
```

When the build exists:

```bash
meson devenv -C "$BUILD_DIR" COMMAND [ARG...]
```

If it does not exist, the command can still run without the custom Mesa environment.

## Configuration

Template:

```text
config/fatix-game.conf
```

The installer places the local configuration at:

```text
~/.config/fatix-game/config
```

Main settings:

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

The installer creates:

```text
~/.local/bin/fatix-game
~/.local/bin/sober-fatix
~/.local/bin/fatix-game-check
~/.config/fatix-game/config
```

## Usage

```bash
fatix-game COMMAND [ARG...]
```

Examples:

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

This launcher uses `FLATPAK_GL_DRIVERS=fatix` and starts Sober through Fatix Game Mode.

## Repository Layout

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

Licensed under the **MIT License**. See [`LICENSE`](LICENSE).
