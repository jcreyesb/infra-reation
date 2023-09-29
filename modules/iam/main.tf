
// AWS IAM Linked Role used for ecs service
resource "aws_iam_role" "ecs_service_terraform" {
  name               = "ecsServiceRoleTerraform"
  assume_role_policy = data.aws_iam_policy_document.ecs_service.json

  tags    = {
     
        Name = "Service Rol"
        Env = "production"
        ManagedBy = "Terraform"		
        
     }
}
resource "aws_iam_role_policy_attachment" "ecs_service_ecstask" {
  role       = aws_iam_role.ecs_service_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}


resource "aws_iam_role_policy_attachment" "ecs_service_secrets" {
  role       = aws_iam_role.ecs_service_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"

}
resource "aws_iam_role_policy_attachment" "route53" {
  role       = aws_iam_role.ecs_service_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"

}

resource "aws_iam_role_policy_attachment" "route53domains" {
  role       = aws_iam_role.ecs_service_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53DomainsFullAccess"

}



// AWS IAM Role Policy used for ecs service
resource "aws_iam_role_policy" "ecs_service" {
  name   = "ecsTaskRolePolicyTerraform"
  policy = data.aws_iam_policy_document.ecs_service_policy.json
  role   = aws_iam_role.ecs_service_terraform.id
}

// AWS IAM Policy in format JSON for linked role ecs service
data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:Describe*",
      "route53:*",
      "route53domains:*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
      "codedeploy:CreateApplication",
      "codedeploy:CreateDeployment",
      "codedeploy:CreateDeploymentGroup",
      "codedeploy:GetApplication",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentGroup",
      "codedeploy:ListApplications",
      "codedeploy:ListDeploymentGroups",
      "codedeploy:ListDeployments",
      "codedeploy:StopDeployment",
      "codedeploy:GetDeploymentTarget",
      "codedeploy:ListDeploymentTargets",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:GetApplicationRevision",
      "codedeploy:RegisterApplicationRevision",
      "codedeploy:BatchGetApplicationRevisions",
      "codedeploy:BatchGetDeploymentGroups",
      "codedeploy:BatchGetDeployments",
      "codedeploy:BatchGetApplications",
      "codedeploy:ListApplicationRevisions",
      "codedeploy:ListDeploymentConfigs",
      "codedpeloy:ContinueDeployment",
      "sns:ListTopics",
      "cloudwatch:DescribeAlarms",
      "lambda:ListFunctions",
    ]
  }
}

// AWS IAM Policy in format JSON for linked role ecs task
data "aws_iam_policy_document" "ecs_service" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ecs.amazonaws.com",
        "s3.amazonaws.com",
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}



/*
ECS Execution
*/

// IAM Policy for task execution role
data "aws_iam_policy_document" "ecs_exec" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecs:DescribeTaskDefinition",
      "ecs:ListServices",
      "ecs:DescribeServices",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
    ]
  }
}

// AWS IAM Role used for ecs task execution
resource "aws_iam_role" "ecs_exec_terraform" {
  name               = "ecsExecTaskRoleTerraform"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_exec.json
    tags    = {
     
        env = "production"
        ManagedBy = "Terraform"		
        Name = "exec Rol"
     }
  
}

resource "aws_iam_role_policy_attachment" "ecs_exec_task" {
  role       = aws_iam_role.ecs_exec_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}


resource "aws_iam_role_policy_attachment" "ecs_exec_secrets" {
  role       = aws_iam_role.ecs_exec_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"

}


// AWS IAM Role Policy used for ecs task execution
resource "aws_iam_role_policy" "ecs_exec" {
  name   = "ecsExecRolePolicyTerraform"
  policy = data.aws_iam_policy_document.ecs_exec.json
  role   = aws_iam_role.ecs_exec_terraform.id
}

data "aws_iam_policy_document" "additional_permissions_ecs_execution" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecs:ListServices",
      "ecs:DescribeServices",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = ["s3:*"]
  }
}

// Additional permissions task execution
resource "aws_iam_role_policy" "additional_permissions_ecs_execution" {
  name   = "ecsExecution_additional_Terraform"
  role   = aws_iam_role.ecs_exec_terraform.id
  policy = data.aws_iam_policy_document.additional_permissions_ecs_execution.json
}

/*
ECS Task
*/

// AWS IAM Policy in format JSON for linked role ecs task
data "aws_iam_policy_document" "ecs_task" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
        "s3.amazonaws.com",
      ]
    }
  }
}

// - IAM role that the Amazon ECS container agent and the Docker daemon can assume
data "aws_iam_policy_document" "ecs_task_exec" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
        "s3.amazonaws.com",
      ]
    }
  }
}

// AWS IAM Role used for ecs task
resource "aws_iam_role" "ecs_task_terraform" {
  name               = "ecsTaskRoleTerraform"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json
    tags    = {
     
        env = "production"
        ManagedBy = "Terraform"		
        Name = "Task Rol"
     }


}

resource "aws_iam_role_policy_attachment" "ecs_task_task" {
  role       = aws_iam_role.ecs_task_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}


resource "aws_iam_role_policy_attachment" "ecs_task_secrets" {
  role       = aws_iam_role.ecs_task_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"

}



// Additional permissions
resource "aws_iam_role_policy" "additional_permissions_task_exec" {
  name   = "ecsTaskRole_additional_Terraform"
  role   = aws_iam_role.ecs_task_terraform.id
  policy = data.aws_iam_policy_document.additional_permissions_task_exec.json
}

data "aws_iam_policy_document" "additional_permissions_task_exec" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecs:ListServices",
      "ecs:DescribeServices",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:*",
    ]
  }
}

# /*
# ECS Autoscaling
# */

# // AWS IAM Role used for ecs autoscaling
# resource "aws_iam_role" "ecs_autoscale_role" {
#   name               = "ecs_autoscale_role"
#   assume_role_policy = data.aws_iam_policy_document.ecs_autoscaling_policy.json
# }

# // AWS IAM Role Policy used for ecs autoscaling
# resource "aws_iam_role_policy" "ecs_autoscale_role_policy" {
#   name   = "ecs_autoscale_role_policy"
#   policy = data.aws_iam_policy_document.ecs_autoscaling_role_policy.json
#   role   = aws_iam_role.ecs_autoscale_role.id
# }

# // AWS IAM Linked Role in format JSON for autoscaling
# data "aws_iam_policy_document" "ecs_autoscaling_policy" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["application-autoscaling.amazonaws.com"]
#     }
#   }
# }

# // AWS IAM Role Policy in format JSON for autoscaling
# data "aws_iam_policy_document" "ecs_autoscaling_role_policy" {
#   statement {
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "ecs:DescribeServices",
#       "ecs:UpdateService",
#       "cloudwatch:DescribeAlarms",
#     ]
#   }
# }

# /*
# ECS Codedeploy
# */

# // AWS IAM Role used for ecs codedeploy
# resource "aws_iam_role" "ecs_codedeploy" {
#   name = "ecs_codedeploy_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "codedeploy.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF

# }

# // AWS IAM Role Policy in format JSON for codeploy
# data "aws_iam_policy_document" "ecs_codedeploy_role_policy" {
#   statement {
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "ecs:DescribeServices",
#       "ecs:CreateTaskSet",
#       "ecs:UpdateServicePrimaryTaskSet",
#       "ecs:DeleteTaskSet",
#       "elasticloadbalancing:DescribeTargetGroups",
#       "elasticloadbalancing:DescribeListeners",
#       "elasticloadbalancing:ModifyListener",
#       "elasticloadbalancing:DescribeRules",
#       "elasticloadbalancing:ModifyRule",
#       "lambda:InvokeFunction",
#       "cloudwatch:DescribeAlarms",
#       "sns:Publish",
#       "s3:GetObject",
#       "s3:GetObjectMetadata",
#       "s3:GetObjectVersion",
#     ]
#   }
# }

# // Aditional Role policy Iam:passROLE for execute task
# data "aws_iam_policy_document" "ecs_codedeploy_role_policy_task" {
#   statement {
#     effect    = "Allow"
#     resources = [aws_iam_role.ecs_task_terraform.arn]

#     actions = [
#       "iam:PassRole",
#     ]
#   }
# }

# // ECS Codedeploy policy to execute ecs task
# data "aws_iam_policy_document" "ecs_codedeploy_role_policy_task_exec" {
#   statement {
#     effect    = "Allow"
#     resources = [aws_iam_role.ecs_exec.arn]

#     actions = [
#       "iam:PassRole",
#     ]
#   }
# }

# // AWS IAM Role Policy used for codedeploy
# resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
#   role       = aws_iam_role.ecs_codedeploy.name
# }

# // AWS IAM Role Policy used for ecs codedeploy
# resource "aws_iam_role_policy" "ecs_codedeploy_role_policy" {
#   name   = "ecs_codedeploy_role_policy"
#   policy = data.aws_iam_policy_document.ecs_codedeploy_role_policy.json
#   role   = aws_iam_role.ecs_codedeploy.id
# }

# // Attach policies for codedeploy run task, drain, etc
# resource "aws_iam_role_policy" "ecs_codedeploy_role_policy_task" {
#   name   = "ecs_codedeploy_role_policy_task"
#   policy = data.aws_iam_policy_document.ecs_codedeploy_role_policy_task.json
#   role   = aws_iam_role.ecs_codedeploy.id
# }

# resource "aws_iam_role_policy" "ecs_codedeploy_role_policy_task_exec" {
#   name   = "ecs_codedeploy_role_policy_task_exec"
#   policy = data.aws_iam_policy_document.ecs_codedeploy_role_policy_task_exec.json
#   role   = aws_iam_role.ecs_codedeploy.id
# }
