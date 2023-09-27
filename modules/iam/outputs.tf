output "execution_role_arn"{
    value = aws_iam_role.ecs_exec_terraform
}


output "ecs_task_terraform"{
    value = aws_iam_role.ecs_task_terraform.arn
}

output "ecs_service_terraforml"{
    value = aws_iam_role.ecs_service_terraform.arn
}

output "ecs_exec_terraform"{
    value = aws_iam_role.ecs_exec_terraform.arn
}

