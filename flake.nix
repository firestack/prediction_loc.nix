{
	description = "Application packaged using poetry2nix";

	inputs.flake-utils.url = "github:numtide/flake-utils";
	inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = nixpkgs.legacyPackages.${system};
			in
			{
				devShells = rec {
					default = pipenv;
					pipenv = let ppkgs = pkgs.python3Packages; in pkgs.mkShell {
						packages = [
							ppkgs.python
							ppkgs.pip
							pkgs.pipenv
						];
					};
				};
			});
}
