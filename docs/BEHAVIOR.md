# Fatix Game Mode behavior

Created by **ft_aska.90**.

This repository baseline reconstructs the latest Fatix Game Mode behavior used on the author's CachyOS/Xfce/X11 setup.

## What happens when a game starts

`fatix-game COMMAND [ARG...]`:

1. remembers whether `fatix.service` / `fatix-rust.service` were active and stops them;
2. terminates standalone `fatix` / `fatix_rust` processes if they were running;
3. stops the `livew` live wallpaper when it can detect that the wallpaper is active;
4. remembers the Xfwm compositor state and temporarily disables compositing when configured;
5. exports the custom Crocus environment:
   - `FATIX_PROFILE=balanced`
   - `FATIX_SIMD_HEURISTIC=1`
   - `MESA_LOADER_DRIVER_OVERRIDE=crocus`
   - `vblank_mode=0`
6. launches the command through `meson devenv -C ~/fatix-crocus/build` when that custom Mesa build exists;
7. watches `_NET_ACTIVE_WINDOW` / `_NET_WM_STATE_FULLSCREEN` through `xprop` every 0.25 seconds.

## Fullscreen-aware pause logic

The optimizer does **not** freeze the whole desktop.

Only GUI applications belonging to the current user are candidates for `SIGSTOP`, and only while the active window reports `_NET_WM_STATE_FULLSCREEN`.

The following classes of processes are protected from pausing:

- Xorg / X11 session;
- `xfwm4`, `xfce4-panel`, `xfdesktop`, Xfce session/settings/power/notification processes;
- PipeWire / PulseAudio / WirePlumber;
- D-Bus and systemd session processes;
- networking and desktop policy/storage/power services;
- Steam, Steam WebHelper, Proton, Wine, Gamescope and GameMode;
- `btop` / `htop`;
- common terminals and shells;
- SSH;
- the launched game process tree;
- the currently active fullscreen window PID.

When the active window stops being fullscreen (for example during Alt+Tab), every process paused by this script is immediately resumed with `SIGCONT`. This is the core change that prevents the previous behavior where leaving a fullscreen game could make the desktop appear stuck.

## Cleanup

On normal game exit, SIGINT, or SIGTERM, the script:

- resumes every process it paused;
- restores the previous Xfwm compositor state;
- restarts the live wallpaper only if it appeared to be running before game mode;
- restarts the Fatix services/process only if Fatix was active before game mode.

A hard `SIGKILL`, power loss, or session crash cannot run shell cleanup logic. If that happens, inspect stopped processes with:

```bash
ps -u "$USER" -o pid=,stat=,comm= | awk '$2 ~ /^T/ {print}'
```

Resume only the affected PID after checking it:

```bash
kill -CONT <PID>
```

## Steam

For a Steam game, use Fatix Game Mode as the launch wrapper for the game command rather than launching the Steam client itself through it. A typical Steam launch option is:

```text
fatix-game %command%
```

## Sober

`sober-fatix` uses:

```text
FLATPAK_GL_DRIVERS=fatix
```

and then launches:

```bash
fatix-game flatpak run org.vinegarhq.Sober
```

This assumes the custom Flatpak GL driver named `fatix` already exists on the system.
