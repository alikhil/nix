{
  run-nix = "nix run nix-darwin --show-trace -- switch --flake ~/projects/alikhil/nix";
  colima-start = "colima start --ssh-agent --cpu 4 --memory 4 --arch x86_64 --mount-type 9p -v";
  gcloud-auth = "gcloud auth login && gcloud auth application-default login";
}