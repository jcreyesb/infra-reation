resource "aws_alb" "alb" {
    name = var.proyecto
    internal = false
    load_balancer_type = "application"
    

    //SG publico
    security_groups = [ var.security_group ]
    subnets = [var.public-subnet-1,var.public-subnet-2,var.public-subnet-3]

    tags = {
     name = var.proyecto 
     env = "production"
     ManagedBy = "Terraform"	
  }

  
}
resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.http_port}"
  protocol          = "${var.http_protocol}"

  default_action {
    type = "redirect"
    redirect {
      port        = "${var.https_port}"
      protocol    = "${var.https_protocol}"
      status_code = "HTTP_301"
    }
    target_group_arn = "${aws_alb_target_group.tg-production.arn}"

      
    }
}


 resource "aws_alb_listener" "https" {
   load_balancer_arn = "${aws_alb.alb.arn}"
   port              = "${var.https_port}"
   protocol          = "${var.https_protocol}"
   ssl_policy        = var.ssl_policy
   certificate_arn = "${var.certificate}" 
   default_action {
     type             = "forward"
     target_group_arn = "${aws_alb_target_group.tg-production.arn}"
   }
 }

  resource "aws_alb_listener" "app" {
   load_balancer_arn = "${aws_alb.alb.arn}"
   port              = "${var.app_port}"
   protocol          = "${var.http_protocol}"
   default_action {
     type             = "forward"
     target_group_arn = "${aws_alb_target_group.tg-production.arn}"
   }
 }


# data "dns_a_record_set" "albdns" {
#   host = aws_lb.alb.dns_name
# }
