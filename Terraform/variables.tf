variable "rg_name" {
  type    = string
  default = "rg-apexshield-dev"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "acr_name" {
  type        = string
  description = "Must be globally unique (lowercase alphanumeric only)"
  default     = "apexshieldacrdev"
}

variable "aks_name" {
  type    = string
  default = "aks-apexshield-dev"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for Jenkins VM"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyc1nwZG2YFf/btBCx+38qHcEb99O0gkHuQWKFvSlIn01rbpxoEM79K+Td4Cps7SIGCNNystbdvU+rEOcgcLRQucVvwMcJTePg1cfa2WYRIhi96Zk99UUcaxtD0w8V7aveSAd/qdXk3tzJPwM80MRmSXULMIf5mlbhV+EYnut/lR8vSZVvzXFnQG2V0exmI3SXcEB+pD7YDnHlEgU8XgZWfZCwhYEoIm/fwFm8kVqtVISifXdZ9It9UVvvG5tM+RdUO2D/Y6tnND1m3qzbLakHihFZ3uUshsTbPAsFgmUYrl7qxSa1P49QuPa8iU/I9yACEcI9wc06tJqsnGLO/0fo6OtfJgCRbUmFzgggZgrB675zwTdUFLWIVPPFKcP7L61wLBv7wDj3ACzOiEErLNeXzbSe/InAm+hfe8Nzd8UQYrZ9d0XnZTrlKR/FamfK6AZXnWQ5HxOPD76xs6wHLGtabyvcMhVpe4l9/JZeKRHlXBJX1Ux0KUofmlt18w65SkAl3BFUnoi5zk4PYQU6EBZywv/9Ej0B3Ry4TA0vjPp5jMnLfrKQUF8zYwou+PjRQZwgPhVDydPiJSnzoIXNZ5OYmxy8mMCvRWnbrIwMVHRtLBPzhSOSw3Dm2gxqASjIMjlvBUkLL/gGJJNzHtZg2RG9h4/Ql5XJfVY5F8fD+m3qgQ== aksha@Akshaya"
}
