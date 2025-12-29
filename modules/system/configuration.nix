{ config, pkgs, inputs, lib, ... }:

{
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

  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
		pciutils
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

	systemd.tmpfiles.rules = [
		"a+ /home/aeg/ - - - - u:komga:rx"
		"a+ /home/aeg/Media/ - - - - u:komga:rx"
		"A+ /home/aeg/Media/Books/ - - - - u:komga:rwx"
		"a+ /home/aeg/Media/Books/ - - - - d:u:komga:rwx"
	];

  system.stateVersion = "26.05";
}
