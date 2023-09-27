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
     provisioner = "terraform"	
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
   #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
   #certificate_arn   =  "${aws_lb_listener_certificate.lb-cert.id}"
   #certificate_arn = "${aws_acm_certificate.certificate.arn}" 
   certificate_arn = "arn:aws:acm:us-east-2:283746063619:certificate/203a0a59-a026-4427-af63-50f37775687f"    
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