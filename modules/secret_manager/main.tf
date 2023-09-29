resource "aws_secretsmanager_secret" "secret_manager" {
  name = "secreto3"
    tags = {
      ManagedBy = "Terraform",
  }
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = aws_secretsmanager_secret.secret_manager.id
  secret_string = jsonencode({
    SECRET_VALUE = "CHANGEME",
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}