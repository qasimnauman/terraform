// modules/devops_access/main.tf

variable "resource_group_name" { type = string }
variable "aks_cluster_name" { type = string }
variable "acr_name" { type = string }
variable "group_object_id" { type = string }
variable "user_principal_names" { type = list(string) }

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "aks_access" {
  scope                = data.azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.group_object_id
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = var.group_object_id
}

data "azuread_user" "selected" {
  for_each            = toset(var.user_principal_names)
  user_principal_name = each.value
}

resource "azuread_group_member" "selected" {
  for_each         = data.azuread_user.selected
  group_object_id  = var.group_object_id
  member_object_id = each.value.object_id
}

provider "kubernetes" {
  alias = var.subscription_id

  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

resource "kubernetes_cluster_role" "devops" {
  metadata { name = "devops-cluster-operator" }
  provider = kubernetes

  rule {
    api_groups = ["apps", "extensions"]
    resources  = ["deployments", "replicasets", "statefulsets", "daemonsets"]
    verbs      = ["get", "list", "watch", "update", "patch", "scale"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch", "delete"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "devops_binding" {
  provider = kubernetes
  metadata { name = "devops-operator-binding" }
  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.devops_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = var.group_object_id
    api_group = "rbac.authorization.k8s.io"
  }
}


variable "subscription_id" { type = string }
variable "resource_group_name" { type = string }
variable "aks_cluster_name" { type = string }
variable "acr_name" { type = string }
variable "group_object_id" { type = string }
variable "user_principal_names" { type = list(string) }

provider "azurerm" {
  alias           = var.subscription_id
  subscription_id = var.subscription_id
}

data "azurerm_kubernetes_cluster" "aks" {
  provider            = azurerm
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

data "azurerm_container_registry" "acr" {
  provider            = azurerm
  name                = var.acr_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "aks_access" {
  provider             = azurerm
  scope                = data.azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.group_object_id
}

resource "azurerm_role_assignment" "acr_push" {
  provider             = azurerm
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = var.group_object_id
}

# only add these specific users to the group:
data "azured1" "users" {
  for_each            = toset(var.user_principal_names)
  user_principal_name = each.value
}

resource "azuread_group_member" "users" {
  for_each         = data.azured1.users
  group_object_id  = var.group_object_id
  member_object_id = each.value.object_id
}

# now bind your Kubernetes RBAC exactly as before,
# using the aliased kubernetes provider:
provider "kubernetes" {
  alias = var.subscription_id

  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

resource "kubernetes_cluster_role" "devops_role" {
  provider = kubernetes

  metadata { name = "devops-cluster-operator" }

  rule {
    api_groups = ["apps", "extensions"]
    resources  = ["deployments", "replicasets", "statefulsets", "daemonsets"]
    verbs      = ["get", "list", "watch", "update", "patch", "scale"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch", "delete"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "devops_binding" {
  provider = kubernetes

  metadata { name = "devops-operator-binding" }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.devops_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = var.group_object_id
    api_group = "rbac.authorization.k8s.io"
  }
}
