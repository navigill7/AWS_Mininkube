resource "aws_security_group" "strapi_security_group" {
  name        = "strapi_security_group"
  description = "Security group for Strapi application"
  vpc_id      = var.vpc_id
  
}


resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.strapi_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.strapi_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
    from_port         = 22 
    ip_protocol       = "tcp"
    to_port           = 22
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_strapi" {
  security_group_id = aws_security_group.strapi_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
    from_port         = 1337 
    ip_protocol       = "tcp"
    to_port           = 1337
  
}


resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.strapi_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

