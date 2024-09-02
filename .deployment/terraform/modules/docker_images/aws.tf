resource "aws_ecr_repository" "example" {
  name = "example-repo"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.example.repository_url
}
