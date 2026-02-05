{config, lib, pkgs, ...}:

let
	cfg = config.selfhosting.llm;
	llama3 = pkgs.fetchurl {
		url = "https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf";
		sha256 = "sha256-ewZPWEK/lTLJFFbe2iiKG2cjl6VPpymqZllShjAzVXw=";
	};
	stheno = pkgs.fetchurl {
		url = "https://huggingface.co/bartowski/L3-8B-Stheno-v3.2-GGUF/resolve/main/L3-8B-Stheno-v3.2-Q4_K_M.gguf";
		sha256 = "sha256-jpjBlT+cBOBg/ZZAu+hmaFyEQ2OiNg8JCZt5xskZX8Q=";
	};
	llama-cpp-cuda = pkgs.llama-cpp.override {
		cudaSupport = true;
		blasSupport = true;
	};
	llama-cmd = modelPath: "${lib.getExe' llama-cpp-cuda "llama-server"} --port \${PORT} -m ${modelPath} -c 8192 --no-webui -ngl 32";
in
{
	config = lib.mkIf cfg.enable {
		services.llama-swap = {
			enable = true;
			port = 8080;
			settings = {
				models = {
					"llama3" = {
						cmd = llama-cmd llama3;
						ttl = 150;
					};
					"stheno" = {
						cmd = llama-cmd stheno;
						ttl = 150;
					};
				};
			};
		};
	};
}
