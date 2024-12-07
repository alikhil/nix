{
  run-nix = "nix run nix-darwin -- switch --flake ~/nix#mini";
  colima-start = "colima start --ssh-agent --cpu 4 --memory 4 --arch x86_64 --mount-type 9p -v --save-config";
}
