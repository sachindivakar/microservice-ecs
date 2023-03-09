# resource "random_password" "master_password" {
#   length  = 16
#   special = false
# }

# # resource "aws_rds_cluster" "default" {
# #   cluster_identifier = "my-cluster"
  
# #   master_username = "admin"
# #   master_password = random_password.master_username.result

# #   # other configurations
# #   # .
# #   # .
# #   # .
# # }

# # resource "aws_db_subnet_group" "_" {
# #   name       = "${local.resource_name_prefix}-${var.identifier}-subnet-group"
# #   subnet_ids = var.subnet_ids
# # }


resource "aws_db_instance" "db_test" {
  allocated_storage    = 10
  db_name              = var.dbname
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  skip_final_snapshot  = true
  # Set the secrets from AWS Secrets Manager
  username = var.username
  password =  var.password

  publicly_accessible = true

}

# resource "aws_secretsmanager_secret" "rds_creds" {
#   name = "rds_creds"

#   recovery_window_in_days = 0
# }

# resource "aws_secretsmanager_secret_version" "rds_creds" {
#   secret_id     = aws_secretsmanager_secret.rds_creds.id
#   secret_string = <<EOF
# {
#   "username": "${var.db_username}",
#   "password": "${random_password.master_password.result}",
#   "engine": "postgres",
#   "host": "${aws_db_instance.db.endpoint}",
#   "port": ${aws_db_instance.db.port}
# }
# EOF

# depends_on = [
#   aws_db_instance.db,
#   random_password.master_password
# ]
# }