
resource "digitalocean_kubernetes_cluster" "main_cluster" {
  name   = var.clustername
  region = "nyc1"
  version = "1.31.1-do.4"

  node_pool {
    name       = "worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 1  
  }
}

data "digitalocean_kubernetes_cluster" "main_cluster" {
  depends_on = [digitalocean_kubernetes_cluster.main_cluster]
  name   = var.clustername
}

# ##################################
# example - how to view the contents
# ##################################
# resource "local_file" "kubeconfig" {
#     content  = yamlencode({
#         document = data.digitalocean_kubernetes_cluster.main_cluster.kube_config[0].raw_config[0]
#     })
#     filename = "paul_cluster.kubeconfig"
# }

resource "local_file" "kubeconfig" {
  content  = data.digitalocean_kubernetes_cluster.main_cluster.kube_config[0].raw_config
  filename = "${var.clustername}.kubeconfig"
}
