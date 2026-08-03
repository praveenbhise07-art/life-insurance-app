variable "aks_cluster_name" {
  type        = string
  description = "Name of the Azure Kubernetes Service cluster"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "node_count" {
  type        = number
  description = "Number of worker nodes in the cluster"
  default     = 2
}

variable "acr_id" {
  type        = string
  description = "Resource ID of the Azure Container Registry for role assignment"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "dev"
}