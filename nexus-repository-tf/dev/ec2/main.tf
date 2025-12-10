resource "aws_security_group" "nexus-repository-sg" {
  name        = "nexus-repository-sg"
  description = "Allow SSH, HTTP and HTTPs"
  vpc_id      = data.aws_vpc.nexus-repository-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "nexus-repository-eip" {
  domain = "standard"

  tags = {
    Name = "nexus-repository-eip"
    Env  = var.env
  }
}

resource "aws_instance" "nexus-repository" {
  ami           = "ami-004e960cde33f9146"
  instance_type = "t3.medium"
  subnet_id     = data.aws_subnet.nexus-repository-public-subnet.id
  
  # security_groups = [aws_security_group.nexus-repository-sg.name]
  vpc_security_group_ids = [aws_security_group.nexus-repository-sg.id]

  key_name = aws_key_pair.nexus-repository-ssh-key.key_name

  tags = {
    Name = "nexus-repository"
    Env = var.env
  }
}

resource "aws_eip_association" "nexus-eip-assoc" {
  instance_id   = aws_instance.nexus-repository.id
  allocation_id = aws_eip.nexus-repository-eip.id
}

resource "tls_private_key" "nexus-repository-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "nexus-repository-ssh-key" {
  key_name   = "nexus-repository-ssh-key"
  public_key = tls_private_key.nexus-repository-ssh-key.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.nexus-repository-ssh-key.private_key_pem
  sensitive = true
}