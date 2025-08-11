resource "aws_security_group" "main" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_vpc_security_group_ingress_rule" "main" {
  count           = length(var.ingress_rules)
  security_group_id = aws_security_group.main.id
  
  from_port   = var.ingress_rules[count.index].from_port
  to_port     = var.ingress_rules[count.index].to_port
  ip_protocol = var.ingress_rules[count.index].protocol
  cidr_ipv4   = var.ingress_rules[count.index].cidr_blocks[0]
  description = var.ingress_rules[count.index].description

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "main" {
  count           = length(var.egress_rules)
  security_group_id = aws_security_group.main.id
  
  from_port   = var.egress_rules[count.index].from_port
  to_port     = var.egress_rules[count.index].to_port
  ip_protocol = var.egress_rules[count.index].protocol
  cidr_ipv4   = var.egress_rules[count.index].cidr_blocks[0]
  description = var.egress_rules[count.index].description

  tags = var.tags
}