region = "us-east-1"

vpc_cidr_block             = "10.1.0.0/16"
private_subnet_cidr_blocks = ["10.1.0.0/24", "10.1.1.0/24"]
public_subnet_cidr_blocks  = ["10.1.2.0/24", "10.1.3.0/24"]

k8s_cluster_name = "learn-devops"
