{
	description = "Application packaged using poetry2nix";

	inputs.flake-utils.url = "github:numtide/flake-utils";
	inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	inputs.poetry2nix = {
		url = "github:nix-community/poetry2nix";
		inputs.nixpkgs.follows = "nixpkgs";
		inputs.flake-utils.follows = "/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils, poetry2nix }:
		flake-utils.lib.eachDefaultSystem (system:
			let
				# see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
				inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication;
				pkgs = nixpkgs.legacyPackages.${system};
			in
			{
				packages = {
					prediction_loc = mkPoetryApplication {
						projectDir = self;
					};
					default = self.packages.${system}.prediction_loc;
				};

				devShells.default = pkgs.mkShell {
					packages = [ poetry2nix.packages.${system}.poetry ];
				};
			});
}
