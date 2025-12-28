# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  # Bootloader.

	imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];

  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth.enable = true;
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

	boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;

  boot.kernelParams = [
	"quiet"
	"splash"
	"boot.shell_on_fail"
	"udev.log_priority=3"
	"rd.systemd.show_status=auto"
  ];
  boot.loader.timeout = 0;

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
		lowLatency.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
	pciutils
  	eddie
  ];

	programs.git = {
		enable = true;
		config = {
			safe = {
				directory = [
					"/etc/nixos"
					"/home/aeg/.dotfiles"
					"/home/aeg/.cache/nix/tarball-cache"
				];
			};
		};
	};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

	programs.localsend.enable = true;

	systemd.tmpfiles.rules = [
		"a+ /home/aeg/ - - - - u:komga:rx"
		"a+ /home/aeg/Media/ - - - - u:komga:rx"
		"A+ /home/aeg/Media/Books/ - - - - u:komga:rwx"
		"a+ /home/aeg/Media/Books/ - - - - d:u:komga:rwx"
	];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
