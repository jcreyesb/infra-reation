//create vpc
module vpc {
source = "./modules/vpc"
region = var.region
env = var.env
public-subnet-1-cidr = var.public-subnet-1-cidr
public-subnet-2-cidr = var.public-subnet-2-cidr
public-subnet-3-cidr = var.public-subnet-3-cidr
private-subnet-1-cidr = var.private-subnet-1-cidr
private-subnet-2-cidr = var.private-subnet-2-cidr
private-subnet-3-cidr = var.private-subnet-3-cidr
proyecto=var.proyecto
cidr=var.cidr
cidr_all=var.cidr_all
zone1=var.zone1
zone2=var.zone2
zone3=var.zone3


}


module ec2 {
  source = "./modules/ec2"
  region =var.region
  cidr = var.cidr
  http_port = var.http_port
  https_port = var.https_port
  ssh_port = var.ssh_port
  public-subnet-1 = module.vpc.public-subnet-1
  public-subnet-2 = module.vpc.public-subnet-2
  public-subnet-3 = module.vpc.public-subnet-3
  private-subnet-1 = module.vpc.private-subnet-1
  private-subnet-2 = module.vpc.private-subnet-2
  private-subnet-3 = module.vpc.private-subnet-3
  security_group = module.security_groups.public_sg
  ssl_policy = var.ssl_policy
  vpc_id = module.vpc.vpc_id
 http_protocol = var.http_protocol
 https_protocol = var.https_protocol
 app_port = var.app_port
 proyecto = var.proyecto
certificate = module.certs.certificate


}
//module ECR
module ecr{
source="./modules/ecr"
name_ecr = var.name_ecr
} 

//Secret Manager

module secret_manager{
source="./modules/secret_manager"
name = var.name
} 


//module Security Group
module security_groups {
 source = "./modules/security_groups"
 ssl_policy = var.ssl_policy
 vpc_id = module.vpc.vpc_id
 http_port = var.http_port
 https_port = var.https_port
 ssh_port = var.ssh_port
 app_port = var.app_port
 http_protocol = var.http_protocol
 https_protocol = var.https_protocol
 cidr_all = var.cidr_all 
} 

//module Endpoint

module endpoints {
source = "./modules/endpoints"
vpc_id=module.vpc.vpc_id
private-subnet-1=module.vpc.private-subnet-1
private-subnet-2=module.vpc.private-subnet-2
private-subnet-3=module.vpc.private-subnet-3 
security_group = module.security_groups.private_sg
service_name = var.service_name
}


//iam rol
module iam {
    source = "./modules/iam"
    
}

//ecs
module ecs {
  source ="./modules/ecs"
  proyecto=var.proyecto
  region = var.region
  cidr = var.cidr
private-subnet-1=module.vpc.private-subnet-1
private-subnet-2=module.vpc.private-subnet-2
private-subnet-3=module.vpc.private-subnet-3 
ssh_port = var.ssh_port
http_port = var.http_port
https_port = var.https_port

execution_role = module.iam.execution_role_arn.arn
task_role = module.iam.ecs_task_terraform
security_group = module.security_groups.private_sg
target_group_arn = module.ec2.tg-production
}

# //certificate
 module certs {
 source = "./modules/certs"
 domain =var.domain
 proyecto = var.proyecto
 zone = module.route53.zone

 }

#route 53
module route53 {
source = "./modules/route53"
domain_name = var.domain_name 
record_name = var.record_name
proyecto = var.proyecto
alb_id= module.ec2.albid
albdns_dns = module.ec2.albdns
   }