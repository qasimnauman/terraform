# terraform {
#   required_providers {
#     azurerm = {
#       source = "hashicorp/azurerm"
#     }
#     azuread = {
#       source = "hashicorp/azuread"
#     }
#     kubernetes = {
#       source = "hashicorp/kubernetes"
#     }
#   }
# }

# # 🔧 AzureAD provider (shared)
# provider "azuread" {}

# # 🔧 Define all azurerm providers (predefined aliases — MUST match keys in local.user_configs)
# provider "azurerm" {
#   alias           = "sub1"
#   subscription_id = "11111111-aaaa-bbbb-cccc-111111111111"
#   features        = {}
# }

# provider "azurerm" {
#   alias           = "sub2"
#   subscription_id = "22222222-aaaa-bbbb-cccc-222222222222"
#   features        = {}
# }

# # 👥 Define all user/group configurations
# locals {
#   user_configs = {
#     sub1 = {
#       subscription_id    = "11111111-aaaa-bbbb-cccc-111111111111"
#       resource_group     = "zpayd-online-resource"
#       aks_name           = "zpayd-online"
#       acr_name           = "zpaydonline"
#       user_object_ids    = ["f5025280-72d3-46c5-8dc1-39485cd00355"] # arslan
#       group_name         = "DevOps-Engineers-PCI"
#     }
#     sub2 = {
#       subscription_id    = "22222222-aaaa-bbbb-cccc-222222222222"
#       resource_group     = "prod-rg"
#       aks_name           = "prod-aks"
#       acr_name           = "prodacr"
#       user_object_ids    = ["f1234567-aaaa-bbbb-cccc-123456789000"] # another user
#       group_name         = "Platform-Team"
#     }
#   }
# }

# # 📁 Azure AD Groups
# resource "azuread_group" "devops_group" {
#   for_each         = local.user_configs
#   display_name     = each.value.group_name
#   security_enabled = true
# }

# # 👤 Group Memberships
# resource "azuread_group_member" "members" {
#   for_each = {
#     for sub_key, sub_val in local.user_configs :
#     for user_id in sub_val.user_object_ids :
#     "${sub_key}-${user_id}" => {
#       group_key  = sub_key
#       object_id  = user_id
#     }
#   }

#   group_object_id  = azuread_group.devops_group[each.value.group_key].id
#   member_object_id = each.value.object_id
# }

# # ☸️ AKS Reference
# data "azurerm_kubernetes_cluster" "aks" {
#   for_each            = local.user_configs
#   provider            = azurerm.${each.key}
#   name                = each.value.aks_name
#   resource_group_name = each.value.resource_group
# }

# # 📦 ACR Reference
# data "azurerm_container_registry" "acr" {
#   for_each            = local.user_configs
#   provider            = azurerm.${each.key}
#   name                = each.value.acr_name
#   resource_group_name = each.value.resource_group
# }

# # 🛡️ AKS Role Assignment (Cluster User Role)
# resource "azurerm_role_assignment" "aks_user" {
#   for_each             = local.user_configs
#   provider             = azurerm.${each.key}
#   scope                = data.azurerm_kubernetes_cluster.aks[each.key].id
#   role_definition_name = "Azure Kubernetes Service Cluster User Role"
#   principal_id         = azuread_group.devops_group[each.key].id
# }

# # 🛡️ ACR Role Assignment (AcrPush)
# resource "azurerm_role_assignment" "acr_push" {
#   for_each             = local.user_configs
#   provider             = azurerm.${each.key}
#   scope                = data.azurerm_container_registry.acr[each.key].id
#   role_definition_name = "AcrPush"
#   principal_id         = azuread_group.devops_group[each.key].id
# }

# # ⚙️ Kubernetes Provider (Only for ONE — set default)
# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.aks["sub1"].kube_config[0].host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks["sub1"].kube_config[0].client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.aks["sub1"].kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks["sub1"].kube_config[0].cluster_ca_certificate)
# }

# # 🔐 Cluster Role (only once for demo, adjust if needed per cluster)
# resource "kubernetes_cluster_role" "devops_role" {
#   metadata {
#     name = "devops-cluster-operator"
#   }

#   rule {
#     api_groups = ["apps", "extensions"]
#     resources  = ["deployments", "replicasets", "statefulsets", "daemonsets"]
#     verbs      = ["get", "list", "watch", "update", "patch", "scale"]
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["pods"]
#     verbs      = ["get", "list", "watch", "delete"]
#   }

#   rule {
#     api_groups = ["batch"]
#     resources  = ["jobs", "cronjobs"]
#     verbs      = ["get", "list", "watch", "create", "delete"]
#   }
# }

# # 🔗 Cluster Role Binding
# resource "kubernetes_cluster_role_binding" "devops_binding" {
#   metadata {
#     name = "devops-operator-binding"
#   }

#   role_ref {
#     kind      = "ClusterRole"
#     name      = kubernetes_cluster_role.devops_role.metadata[0].name
#     api_group = "rbac.authorization.k8s.io"
#   }

#   subject {
#     kind      = "Group"
#     name      = local.user_configs["sub1"].group_name
#     api_group = "rbac.authorization.k8s.io"
#   }
# }
