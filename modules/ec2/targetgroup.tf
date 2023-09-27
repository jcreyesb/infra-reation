resource "aws_alb_target_group" "tg-production" {
  name     = var.proyecto
  target_type = "ip"
  port     = var.http_port
  protocol = "HTTP"
  vpc_id      = var.vpc_id
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/"    
    port                = 80
  }
tags    = {
     
        env = "production"
        provisioner = "terraform"		
        Name = "target group"
     }

}

