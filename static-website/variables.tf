variable "project_name" {
  description = "Project name"
  type        = string
}

variable "domain_name" {
  description = "Project Route53 Domain"
  type        = string
}

variable "default_tags" {
  description = "Default tags to write to all resrouces"
  type        = map(any)
  default     = {}
}

