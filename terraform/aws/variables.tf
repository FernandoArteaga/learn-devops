variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The region in which the resources will be created"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "List of availability zones for the selected region"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.1.0.0/16"
  description = "CIDR block range for vpc"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.1.0.0/24", "10.1.1.0/24"]
  description = "CIDR block range for the private subnet"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.1.2.0/24", "10.1.3.0/24"]
  description = "CIDR block range for the public subnet"
}

variable "tags" {
  type = map(string)
  default = {
    solution    = "Learn DevOps"
    environment = "Dev"
  }
  description = "A map of tags to add to all resources"
}

variable "k8s_cluster_name" {
  type        = string
  default     = "learn-devops"
  description = "The name of the Kubernetes cluster"
}
