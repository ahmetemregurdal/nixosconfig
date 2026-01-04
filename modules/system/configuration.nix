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

  networking.networkmanager.enable = true;

	services.speechd.enable = lib.mkForce false;
	programs.nano.enable = lib.mkForce false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Istanbul";

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
  };

  services.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;

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
