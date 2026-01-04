{config, pkgs, lib, ...}:

{
	programs.zsh = {
		enable = true;
		syntaxHighlighting.enable = true;
		autosuggestion.enable = true;
		history = {
			ignoreAllDups = true;
			ignoreDups = true;
			extended = true;
			share = true;
		};
		shellAliases = {
			"ll" = "ls -l";
			"la" = "ls -a";
			"lla" = "ls -al";
			"l" = "ls";
			"c" = "clear";
			"v" = "nvim";
			"cd" = "z";
		};
	};

	userSettings.stylix.enable = true;
	stylix.targets.starship.enable = true;
	programs.starship = {
		enable = true;
		enableZshIntegration = true;
	};
}
