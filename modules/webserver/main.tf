resource "aws_default_security_group" "dev-sg" {
  vpc_id = var.vpc-id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env-prefix}-sg"
  }
}

data "aws_ami" "amazon-ubuntu-machine-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516"]
  }
}

resource "aws_instance" "ec2-instance" {
  ami           = data.aws_ami.amazon-ubuntu-machine-image.id
  instance_type = var.instance-type

  subnet_id              = var.subnet-id
  vpc_security_group_ids = [aws_default_security_group.dev-sg.id]
  availability_zone      = var.availability_zone

  associate_public_ip_address = true
  key_name                    = "Jenkins-Server-KP"
  tags = {
    Name = "${var.env-prefix}-server"
  }
}