data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name

  vpc_security_group_ids = [
    aws_security_group.nginx.id
  ]

  user_data = <<-EOF
              #!/bin/bash

              apt update -y

              apt upgrade -y

              apt install nginx -y

              systemctl enable nginx

              systemctl start nginx


              cat > /var/www/html/index.html <<HTML
              <!DOCTYPE html>
              <html>
              <head>
                <title>Hello Terraform</title>
              </head>

              <body>
                <h1>Hello World from Terraform!</h1>
                <p>Nginx installed automatically using EC2 user_data.</p>
              </body>

              </html>
              HTML

              EOF

  tags = {
    Name = "${var.project_name}-server"
  }
}

#
# SSH key generation
#

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.module}/keys/${var.key_name}.pem"
  file_permission = "0600"
}



resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

