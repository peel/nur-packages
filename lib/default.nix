{ pkgs }:

with pkgs.lib; {
  mkOverlay = username: overlay:
              let homePath = if pkgs.stdenv isDarwin then "Users" else "home";
              in builtins.toPath "/${homePath}/${username}/.config/nixpkgs/overlays/${overlay}.nix";
}

