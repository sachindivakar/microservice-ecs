# outputs.tf

# output "ecr_image_url" {
#   value = aws_ecr_repository.ecr_lab.repository_url
# }

output "alb_hostname" {
  value = aws_alb.main.dns_name
}


output "rds_credentials" {
  value = aws_secretsmanager_secret.rds_creds
}


output "repo_url" {
  value = aws_codecommit_repository.test
  
}