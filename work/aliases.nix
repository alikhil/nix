{
  run-nix = "nix run nix-darwin --show-trace -- switch --flake ~/projects/alikhil/nix";
  gcloud-auth = "gcloud auth login && gcloud auth application-default login";
}
