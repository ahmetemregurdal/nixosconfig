{config, lib, pkgs, ...}:

{
	stylix.targets.limine.enable = true;
  boot.loader.timeout = 3;
	boot.loader.limine = {
		enable = true;
		enableEditor = true;
	};
}
