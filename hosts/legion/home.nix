{lib, pkgs, config, ...}:

{
	config = {
		userSettings = {
			browser = "qutebrowser";
			terminal = "kitty";
			editor = "nixvim";
			stylix.enable = true;
			zathura.enable = true;
			pgp.enable = true;
			rbw = {
				enable = true;
				mail = "ahmetemregurdal2008@gmail.com";
			};
			git.enable = true;
			xdg.enable = true;
			languages = {
				cpp.enable = true;
				nix.enable = true;
			};
			nixcord.enable = true;
			halloy.enable = true;
			beets.enable = true;
			shell = {
				tmux.enable = true;
				useful.enable = true;
				useless.enable = true;
			};
		};
	};
}
