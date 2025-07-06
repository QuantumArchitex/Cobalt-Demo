resource "aws_security_group" "alb_sg" {
  name        = "${var.tenant}-alb-sg"
  description = "Allow HTTPS inbound"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "${var.tenant}-alb-sg"
  }
}

resource "aws_lb" "this" {
  name               = "${var.tenant}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids                       
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "${var.tenant}-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.tenant}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.tenant}-tg"
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.target_id
  port             = 80
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
