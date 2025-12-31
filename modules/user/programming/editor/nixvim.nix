{pkgs, config, lib, inputs, osConfig, ...}:

let
cfg = config.userSettings.nixvim;
language = config.userSettings.languages;
in
{
	options = {
		userSettings.nixvim = {
			enable = lib.mkEnableOption "Enable nixvim";
		};
	};

	imports = [ inputs.nixvim.homeModules.nixvim ];

	config = lib.mkIf cfg.enable {
		userSettings.stylix.enable = true;
		stylix.targets.nixvim.enable = true;
		programs.nixvim = {
			enable = true;
			editorconfig.enable = true;
			clipboard.providers.wl-copy.enable = true;
			opts = {
				number = true;
				relativenumber = true;
				tabstop = 2;
				shiftwidth = 2;
				smartindent = true;
				cursorline = true;
			};
			globals = {
				mapleader = " ";
				maplocalleader = " ";
			};
			lsp = {
				inlayHints.enable = true;
				servers = {
					ccls.enable = language.cpp.enable;
					nixd = {
						enable = false;
						config = {
							formatting.command = [ "alejandra" "--experimental-config" "${config.home.homeDirectory}/.config/alejandra.toml" ];
							nixpkgs.expr = "import (builtins.getFlake \"/etc/nixos\").inputs.nixpkgs { }";
							options = {
								nixos = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.${osConfig.networking.hostName}.options";
							};
						};
					};
					qmlls.enable = language.qml.enable;
				};
			};
			plugins.treesitter = {
				enable = true;
				grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [
						bash
						json
						lua
						markdown
						make
						nix
						regex
						toml
						vim
						vimdoc
						xml
						yaml
						css
						cpp
						qmljs
				];

				settings.highlight.enable = true;
			};

			plugins.mini-starter = {
				enable = true;
				settings = {
					header = ''
███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
						'';

				};
			};

			plugins.mini-icons.enable = true;

			plugins.lspconfig.enable = true;

			plugins.mini-ai.enable = true;

			plugins.blink-cmp = {
				enable = true;
				settings = {
					completion.ghost_text = {
						enabled = true;
					};
					fuzzy = {
						implementation = "lua";
					};
				};
			};

			plugins.web-devicons.enable = true;

			plugins.codesnap.enable = true;

			plugins.comment-box.enable = true;
			
			plugins.competitest = {
				enable = true;
				settings = {
					testcases_use_single_file = true;
				};
			};

			plugins.telescope = {
				enable = true;
			};

			plugins.nerdy = {
				enable = true;
				enableTelescope = true;
			};

			plugins.which-key = {
				enable = true;
			};

			plugins.lualine = {
				enable = true;
			};
			
			plugins.hmts.enable = true;
		};
	};
}
