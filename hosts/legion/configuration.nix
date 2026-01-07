{config, lib, pkgs, ...}:

{
	config = {
		systemSettings = {
			stylix.theme = "kanagawa-dragon";
			stylix.enable = true;
			niri.enable = true;
			users = [ "aeg" ];
			adminUsers = [ "aeg" ];
			security.doas.enable = true;
			security.firewall.enable = true;
			cachy.enable = false;
			bluetooth.enable = true;
			displaymanager.enable = true;
			gaming.enable = true;
		};
		home-manager.users.aeg.userSettings = {
			name = "Ahmet Emre Gürdal";
			email = "gurdalahmetemre@disroot.org";
		};
		users.users.aeg.description = "Ahmet Emre Gürdal";
		users.users.aeg.shell = pkgs.zsh;
		programs.zsh.enable = true;
		selfhosting = {
			enable = true;
			forgejo.enable = true;
			llm.enable = true;
		};
	};
}
