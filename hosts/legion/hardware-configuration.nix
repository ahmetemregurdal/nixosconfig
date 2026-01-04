{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "mt7921e" "amdgpu" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
	boot.kernelParams = [ "amd_pstate=active" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/06a1be43-5398-4976-b759-7e8e9053cae4";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B0B9-C9A7";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/home/aeg" =
    { device = "/dev/disk/by-uuid/4d851d29-9652-4355-8bb9-59b2ecbe898d";
      fsType = "xfs";
    };

  swapDevices = [
		{
			device = "/swapfile";
			size = 32768;
		}
	];

	# zramSwap.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  services.xserver.videoDrivers = ["nvidia"];
	services.tlp.enable = true;
	services.fstrim.enable = true;
  hardware = {
		graphics = {
			enable = true;
			enable32Bit = true;
		};
		amdgpu.initrd.enable = false;
		nvidia = {
			modesetting.enable = true;
			nvidiaSettings = false;
			open = true;
			powerManagement.enable = true;
			package = config.boot.kernelPackages.nvidiaPackages.production;
			prime = {
				amdgpuBusId = "PCI:6:0:0";
				nvidiaBusId = "PCI:1:0:0";
				offload = {
					enable = true;
					enableOffloadCmd = true;
				};
			};
		};
  };
}


