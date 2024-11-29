output "kubeconfig_command" {
  value = "SET_ENV_VARIABLE: $env:KUBECONFIG='${path.cwd}/${var.clustername}.kubeconfig'"
}