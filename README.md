# NixOS-Frisia
Konfigurationsmodule für NixOS

## Features

Stellt ein NixOS-Basierten Rechner für Musik- und Büroarbeit ein.

## Installation

Folgendes unter `imports` in `/etc/nixos/configuration.nix` eintragen:

```nix
"${builtins.fetchurl { url = "https://raw.githubusercontent.com/j0hax/NixOS-Frisia/main/fs-config.nix"; }}"
```
