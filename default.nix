{ pkgs ? import <nixpkgs> {} }:

let
  ppkgs = import ./pkgs { inherit pkgs; };
  nkgs = pkgs // ppkgs;
in {
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  darwin-modules = import ./darwin-modules { pkgs = npkgs; };
  overlays = import ./overlays;
} // ppkgs
