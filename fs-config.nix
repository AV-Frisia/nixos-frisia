# NixOS Konfiguration für Anwendung innerhalb der AV Frisia

{ config, pkgs, lib, ... }: {

  # Namen festlegen  
  system.nixos.tags = [ "Frisia" ];

  # Graphische Oberfläche aktivieren
  imports = [ <nixpkgs/nixos/modules/profiles/graphical.nix> ];

  # Dual-Boot Ermöglichen
  boot.loader.grub.useOSProber = lib.mkDefault true;

  # Bootmenue Verstecken
  boot.loader.timeout = lib.mkDefault 0;
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 3;
  boot.loader.grub.configurationLimit = lib.mkDefault 3;

  # Schönes Bootscreen
  boot.plymouth = lib.mkDefault {
    enable = true;
    logo = ./zirkel.png
  };

  # Auslagerrungsspeicher komprimieren -- lässt u.A. SSDs länger halten
  zramSwap.enable = true;

  # Tmpfs ist deutlich schneller und löscht temporäre Dateien beim Neustart
  boot.tmpOnTmpfs = lib.mkDefault true;

  # Automatische Updates einschalten
  system.autoUpgrade = lib.mkDefault {
    enable = true;
    dates = "monthly";
  };

  # Automatische Optimierungen erlauben
  nix.autoOptimiseStore = lib.mkDefault true;
  nix.gc = lib.mkDefault {
    automatic = true;
    options = "-d";
  };

  # Performance-Orientierten Kernel verwenden
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

  # Security-Keys statt Passwort verwenden
  security.pam.u2f = {
    enable = true;
    interactive = true;
    cue = true;
  };

  # Nutzer festlegen
  users.mutableUsers = lib.mkDefault false;

  users.users.frise = {
    description = "Frise";
    isNormalUser = true;
    hashedPassword = "";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRUDMUZD30eDGJ+08Q653fQB13NQSFeVMlxgGjyxzK8xRPykm8uCHGMBNrC5iR+8Lu4hhsuEeO8fGzOACqCeBSemKl/plzeroxXKWR2p+Cy0Qh1NMpMcl6Jxi0rcIdXAOUPFr38/BcmNMSrmBuuwOX1/QCQhs6G0TwyuOBJk8G9N/1R3BKMsBeRe8G5gyG6XhUtrrAKTv97BzY2IaPxNZYPFgf0EKDpA39rYpPp+CLRN0N1N+viCbX2jCMW8QRz1kjtQyzvO1v4uyhxBDq2YDvPZws8sgEBtNz5IU6ERHiec4L+j38xW/jdURFJrDgmVVlOJ2btx8Uw928sJg0tDjxwcBzcUv6QC0/ds59EPQcI8yxZUpRPCYm7hwwCGvhX/IE5lmCrSUEQ+Xj0poxOml0IbzjUxdKOPpSC75nR83OALGcSBJ+b7QQV0ZHWWd75o6NNkpIHuf2j3kjIwFBtIuQukJ2CA54A3/jkGma7M8789KeUSCZ4OBfmCfNcDlQ5n0= johannes@kirby"
    ];
  };

  # Auto-Login für den Benutzer frise
  services.xserver.displayManager = lib.mkDefault {
    autoLogin.enable = true;
    autoLogin.user = "frise";
  };

  # System auf Deutsch stellen
  i18n.defaultLocale = lib.mkDefault "de_DE.UTF8";
  services.xserver.layout = lib.mkDefault "de";
  console.keyMap = lib.mkDefault "de";

  # Zeitzone
  time.timeZone = lib.mkDefault "Europe/Berlin";

  # Pakete, welche mitinstalliert werden
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    spotify
    google-chrome
    libreoffice
    prusa-slicer
    openscad
    wineWowPackages.stable
    gramps
    texlive.combined.scheme-full
    kile
    imagemagick
    vlc
    partition-manager
    powerdevil
    spectacle
    kate
    digikam
    ark
    kcalc
    okular
    gwenview
    skanlite
    zoom-us
    kronometer
  ];

  # Zusätzliche Schriftarten für Büroanwendungen
  fonts = { fonts = with pkgs; [ corefonts ]; };

  # Remote-Zugriff für Administration
  services.openssh = lib.mkDefault {
    enable = true;
    startWhenNeeded = true;
    forwardX11 = true;
  };
  services.x2goserver.enable = true;
  boot.initrd.network.ssh.enable = true;
  services.sshguard.enable = lib.mkDefault true;

  # CUPS zum mühelosen Drucken
  services.printing.enable = lib.mkDefault true;

  # Ton
  sound.enable = lib.mkDefault true;
  hardware.pulseaudio.enable = lib.mkDefault true;

  # Festplatten Überwachen
  services.smartd = lib.mkDefault {
    enable = true;
    notifications.x11.enable = true;
  };

  users.motd = lib.mkDefault "Allzeit Voran!";

  nixpkgs.overlays = [
    (self: super: {
      firefox = super.firefox.override { desktopName = "Feuerfux"; };
    })
  ];
}
