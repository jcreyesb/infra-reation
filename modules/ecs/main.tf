resource "aws_ecs_cluster" "proyecto" {
  capacity_providers = ["FARGATE", "FARGATE_SPOT" ]
  name = var.proyecto

  default_capacity_provider_strategy {
     capacity_provider =  "FARGATE_SPOT"
     base = 1
     weight = 4 
  }

tags    = {
     
        env = "production"
        ManagedBy = "Terraform"		
        Name = "Production Cluster"
     }


}

resource "aws_ecs_service" "api-services" {
  name            = "api-services"
  cluster         = aws_ecs_cluster.proyecto.id
  task_definition = aws_ecs_task_definition.task-production.arn
  desired_count   = 1
  launch_type = "FARGATE"
  force_new_deployment = true

  load_balancer {
    target_group_arn = var.target_group_arn.arn
    container_name   = "whoami"
    container_port   = 80
  }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-east-2a, us-east-2b, us-east-2c]"
  # }


network_configuration {
 subnets = [var.private-subnet-1,var.private-subnet-2,var.private-subnet-3]
 security_groups = [ var.security_group ]
 assign_public_ip = false

}

tags    = {
     
        env = "production"
        ManagedBy = "Terraform"		
        Name = "Production Cluster"
     }


}



resource "aws_ecs_task_definition" "task-production" {
  family                   = "proyecto"
  task_role_arn            = var.task_role
  execution_role_arn       = var.execution_role
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]

runtime_platform {
    #operating_system_family = "Linux"
    cpu_architecture        = "X86_64"

  }


tags    = {
     
        env = "production"
        ManagedBy = "Terraform"		
        Name = "Task Definition"
     }


container_definitions = <<TASK_DEFINITION
[
  {
    "name": "whoami",
    "image": "283746063619.dkr.ecr.us-east-2.amazonaws.com/whoami",
    "cpu": 1,
    "memory": 1024,
      "portMappings": [
                {
                    "containerPort": 80,
                    "hostPort": 80,
                    "protocol": "tcp"
                }
            ],

     "secrets": [
                {
                    "name": "WHOAMI_PORT_NUMBER",
                    "valueFrom": "arn:aws:secretsmanager:us-east-2:283746063619:secret:WHOAMI-S2AbH4:WHOAMI_PORT_NUMBER::"
                }
            ],
      
      "tags": [
              {
                    "name": "Cryptobucksapp-task",  
                     "env": "production",
                     "provisioner": "terraform"	
               }],      
    "essential": true
  }

  
]
TASK_DEFINITION


}