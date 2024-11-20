{
  run-nix = "nix run nix-darwin --show-trace -- switch --flake ~/projects/alikhil/nix";
  colima-start = "colima start --ssh-agent --cpu 4 --memory 4 --vm-type vz --vz-rosetta --very-verbose -a aarch64";
  gcloud-auth = "gcloud auth login && gcloud auth application-default login";
}
