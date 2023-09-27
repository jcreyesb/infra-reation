output "proyecto" {
   value = aws_ecs_cluster.proyecto

}

output "task" {
   value = aws_ecs_task_definition.task-production
  
}

output "api-services" {
  value = aws_ecs_service.api-services
}
