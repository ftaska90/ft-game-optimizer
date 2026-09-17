#!/usr/bin/env bash
# FT Game Optimizer installer
# Created by ft_aska.90
# Copyright (c) 2026 ft_aska.90
# SPDX-License-Identifier: MIT

set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/fatix-game"

mkdir -p "$BIN_DIR" "$CONFIG_DIR"

install -m 0755 "$REPO_DIR/scripts/fatix-game" "$BIN_DIR/fatix-game"
install -m 0755 "$REPO_DIR/scripts/sober-fatix" "$BIN_DIR/sober-fatix"

if [[ ! -e "$CONFIG_DIR/config" ]]; then
    install -m 0644 "$REPO_DIR/config/fatix-game.conf" "$CONFIG_DIR/config"
    echo "Installed default config: $CONFIG_DIR/config"
else
    echo "Keeping existing config: $CONFIG_DIR/config"
    echo "Template available at: $REPO_DIR/config/fatix-game.conf"
fi

echo
echo "FT Game Optimizer installed."
echo "Main launcher : $BIN_DIR/fatix-game"
echo "Sober launcher: $BIN_DIR/sober-fatix"
echo "Config        : $CONFIG_DIR/config"
echo
echo "Recommended commands/dependencies:"
echo "  xprop, xfconf-query, systemctl --user, meson, pgrep/pkill, ps, flock"
