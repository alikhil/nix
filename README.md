

# nix

Getting started with nix on macOS.

```shell
sh <(curl -L https://nixos.org/nix/install)

git clone git@github.com:alikhil/nix.git ~/nix

nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"
nix run nix-darwin -- switch --flake ~/nix#mini

darwin-rebuild switch --flake ~/nix#mini
```

## Update

```shell
nix flake update
nix run nix-darwin -- switch --flake ~/nix#mini
```

## Pre-commit

```shell
pre-commit install
```