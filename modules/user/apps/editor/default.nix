{config, pkgs, lib, ...}:

let
	term = config.userSettings.terminal;
	editor = config.userSettings.editor;
in
{
	options = {
		userSettings.editor = lib.mkOption {
			default = "nixvim";
			description = "Default editor";
			type = lib.types.enum [ "nixvim" "helix" ];
		};

		userSettings.spawnEditor = lib.mkOption {
			default = "";
			description = "Command to spawn editor";
			type = lib.types.str;
		};

		userSettings.spawnEditorArgList = lib.mkOption {
			default = [];
			description = "Command to spawn editor";
			type = lib.types.listOf lib.types.str;
		};

		userSettings.spawnEditorTerm = lib.mkOption {
			default = "";
			description = "Command to spawn editor";
			type = lib.types.str;
		};
	};

	config = {
		userSettings.nixvim.enable = lib.mkDefault (editor == "nixvim");
		userSettings.helix.enable = lib.mkDefault (editor == "helix");

		userSettings.spawnEditor = lib.mkMerge [
			(lib.mkIf (editor == "nixvim") ("exec " + term + " -e nvim"))
			(lib.mkIf (editor == "helix") ("exec " + term + " -e hx"))
		];

		userSettings.spawnEditorArgList =
			if (editor == "nixvim") then [term "-e" "nvim"]
			else if (editor == "helix") then [term "-e" "hx"]
			else [];

		userSettings.spawnEditorTerm = lib.mkMerge [
			(lib.mkIf (editor == "nixvim") "nvim")
			(lib.mkIf (editor == "helix") "hx")
		];

		home.sessionVariables = {
			EDITOR = config.userSettings.spawnEditorTerm;
		};
	};
}
