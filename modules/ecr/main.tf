resource "aws_ecr_repository" "repository" {
  name         = var.name_ecr
  force_delete = true

  tags = {
      ManagedBy = "Terraform",
  }
}

resource "null_resource" "push_image" {
  provisioner "local-exec" {
    command = "${path.module}/ecr.sh ${aws_ecr_repository.repository.repository_url}"
  }
}




