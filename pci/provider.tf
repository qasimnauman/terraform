# locals {
#   subs = { for s in var.subscriptions : s.subscription_id => s }
# }

# # ── Subscription 1 ─────────────────────────────────────────

# provider "azurerm" {
#   alias           = "sub1111222233334444"
#   subscription_id = local.subs["1111-2222-3333-4444"].subscription_id
# }

# data "azurerm_kubernetes_cluster" "aks_1111" {
#   provider            = azurerm.sub1111222233334444
#   name                = local.subs["1111-2222-3333-4444"].aks_cluster_name
#   resource_group_name = local.subs["1111-2222-3333-4444"].resource_group_name
# }

# provider "kubernetes" {
#   alias                  = "sub1111222233334444"
#   host                   = data.azurerm_kubernetes_cluster.aks_1111.kube_config[0].host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_1111.kube_config[0].client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_1111.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_1111.kube_config[0].cluster_ca_certificate)
# }

# # ── Subscription 2 ─────────────────────────────────────────

# provider "azurerm" {
#   alias           = "sub5555666677778888"
#   subscription_id = local.subs["5555-6666-7777-8888"].subscription_id
# }

# data "azurerm_kubernetes_cluster" "aks_5555" {
#   provider            = azurerm.sub5555666677778888
#   name                = local.subs["5555-6666-7777-8888"].aks_cluster_name
#   resource_group_name = local.subs["5555-6666-7777-8888"].resource_group_name
# }

# provider "kubernetes" {
#   alias                  = "sub5555666677778888"
#   host                   = data.azurerm_kubernetes_cluster.aks_5555.kube_config[0].host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_5555.kube_config[0].client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_5555.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_5555.kube_config[0].cluster_ca_certificate)
# }
