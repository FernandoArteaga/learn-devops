## Security group for public subnet resources
#resource "aws_security_group" "public_sg" {
#  name   = "public-sg"
#  vpc_id = aws_vpc.main.id
#
#  tags = var.tags
#}
#
## Security group traffic rules for public subnet resources
### Ingress rule
#resource "aws_security_group_rule" "sg_ingress_public_443" {
#  security_group_id = aws_security_group.public_sg.id
#  type              = "ingress"
#  from_port         = 443
#  to_port           = 443
#  protocol          = "tcp"
#  cidr_blocks = [
#    aws_subnet.public_subnet.cidr_block,
#  ]
#
#  depends_on = [
#    aws_subnet.public_subnet,
#  ]
#}
#
#resource "aws_security_group_rule" "sg_ingress_public_80" {
#  security_group_id = aws_security_group.public_sg.id
#  type              = "ingress"
#  from_port         = 80
#  to_port           = 80
#  protocol          = "tcp"
#  cidr_blocks = [
#    aws_subnet.public_subnet.cidr_block,
#  ]
#
#  depends_on = [
#    aws_subnet.public_subnet,
#  ]
#}
#
### Egress rule
#resource "aws_security_group_rule" "sg_egress_public" {
#  security_group_id = aws_security_group.public_sg.id
#  type              = "egress"
#  from_port         = 0
#  to_port           = 0
#  protocol          = "-1"
#  cidr_blocks = [
#    aws_subnet.public_subnet.cidr_block,
#  ]
#
#  depends_on = [
#    aws_subnet.public_subnet,
#  ]
#}
#
## Security group for data plane
#resource "aws_security_group" "data_plane_sg" {
#  name   = "k8s-data-plane-sg"
#  vpc_id = aws_vpc.main.id
#
#  tags = var.tags
#}
#
## Security group traffic rules
### Ingress rule
#resource "aws_security_group_rule" "nodes" {
#  description       = "Allow nodes to communicate with each other"
#  security_group_id = aws_security_group.data_plane_sg.id
#  type              = "ingress"
#  from_port         = 0
#  to_port           = 65535
#  protocol          = "-1"
#  cidr_blocks = [
#    aws_subnet.private_subnet.cidr_block,
#    aws_subnet.public_subnet.cidr_block,
#  ]
#
#  depends_on = [
#    aws_subnet.private_subnet,
#    aws_subnet.public_subnet,
#  ]
#}
#
#resource "aws_security_group_rule" "nodes_inbound" {
#  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#  security_group_id = aws_security_group.data_plane_sg.id
#  type              = "ingress"
#  from_port         = 1025
#  to_port           = 65535
#  protocol          = "tcp"
#  cidr_blocks = [
#    aws_subnet.private_subnet.cidr_block,
#  ]
#
#  depends_on = [
#    aws_subnet.private_subnet,
#  ]
#}
#
### Egress rule
#resource "aws_security_group_rule" "node_outbound" {
#  security_group_id = aws_security_group.data_plane_sg.id
#  type              = "egress"
#  from_port         = 0
#  to_port           = 0
#  protocol          = "-1"
#  cidr_blocks       = ["0.0.0.0/0"]
#}
#
## Security group for control plane
#resource "aws_security_group" "control_plane_sg" {
#  name   = "k8s-control-plane-sg"
#  vpc_id = aws_vpc.main.id
#
#  tags = var.tags
#}
#
## Security group traffic rules
### Ingress rule
#resource "aws_security_group_rule" "control_plane_inbound" {
#  security_group_id = aws_security_group.control_plane_sg.id
#  type              = "ingress"
#  from_port         = 0
#  to_port           = 65535
#  protocol          = "tcp"
#  cidr_blocks = [
#    aws_subnet.private_subnet.cidr_block,
#    aws_subnet.public_subnet.cidr_block,
#  ]
#
#  depends_on = [
#    aws_subnet.private_subnet,
#    aws_subnet.public_subnet,
#  ]
#}
#
### Egress rule
#resource "aws_security_group_rule" "control_plane_outbound" {
#  security_group_id = aws_security_group.control_plane_sg.id
#  type              = "egress"
#  from_port         = 0
#  to_port           = 65535
#  protocol          = "-1"
#  cidr_blocks       = ["0.0.0.0/0"]
#}