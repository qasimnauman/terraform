# variable "subscriptions" {
#   description = "One entry per subscription where we need to grant DevOps access, and the specific AAD users for each."
#   type = list(object({
#     subscription_id       = string
#     resource_group_name   = string
#     aks_cluster_name      = string
#     acr_name              = string
#     user_principal_names  = list(string)  # ← list only the UPNs you want in *this* subscription
#   }))
# }
