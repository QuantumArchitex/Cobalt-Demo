resource "aws_security_group" "compute_sg" {
  name        = "${var.tenant}-compute-sg"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tenant}-compute-sg"
  }
}

resource "aws_instance" "nginx" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.compute_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install nginx1 -y || sudo dnf install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              echo "<h1>Hello from ${var.tenant}</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "${var.tenant}-nginx-instance"
  }
}
