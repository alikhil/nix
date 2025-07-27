{
  kls = "kubectl get pods";
  klsg = "kubectl get pods | grep";
  kl = "kubectl logs";
  kltf = "kubectl logs -f --tail=200";
  kapl = "kubectl apply";
  kapli = "cat <<EOF | kubectl apply -f -";
  king = "kubectl get ing";
  kd = "kubectl describe";
  kpf = "kubectl port-forward";
  kex = "kubectl exec";
  kg = "kubectl get";
  kdel = "kubectl delete";
  kall = "kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found";

  kns = "kubens";
  ktx = "kubectx";
  kctx = "kubectx";
  klss = "kubectl get pods -o custom-columns=NAME:.metadata.name,SELECTOR:.spec.nodeSelector";
  kgn = "kubectl get nodes -L app_type";
  k = "kubectl";
  ktl = "kubectl";
  refreshes = "kubectl annotate --all -A externalsecrets.external-secrets.io force-sync=$(date +%s) --overwrite";
  refreshcss = "kubectl annotate --all -A clustersecretstores.external-secrets.io force-sync=$(date +%s) --overwrite";

  kill_md = "launchctl unload /Library/LaunchAgents/com.microsoft.wdav.tray.plist";

  gitwhere = "git rev-parse --show-toplevel";
  gittags = "git tag --sort=-creatordate";

  randpass = "openssl rand -base64 8 |md5 |head -c25;echo";
  randpassc = "openssl rand -base64 8 |md5 |head -c25 | pbcopy";

  d = "docker";
  dc = "docker compose";
  dup = "docker compose up -d";
  ddown = "docker compose down";
  dlogs = "docker compose logs -f --tail=200";

  tfdoc = "terraform-docs markdown table";
  colima-start = "colima start --ssh-agent --cpu 4 --memory 4 --vm-type vz --vz-rosetta --very-verbose -a aarch64";
  dive = "docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive";
}
