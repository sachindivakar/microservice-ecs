resource "random_password" "master_password" {
  length  = 16
  special = false
}

# resource "aws_rds_cluster" "default" {
#   cluster_identifier = "my-cluster"
  
#   master_username = "admin"
#   master_password = random_password.master_username.result

#   # other configurations
#   # .
#   # .
#   # .
# }

resource "aws_db_subnet_group" "subnet" {
  name       = "subnet-group"
  subnet_ids =  aws_subnet.public.*.id
}

# Traffic to the ECS cluster should only come from the ALB
# resource "aws_security_group" "rds" {
#   name        = "web-appecs-tasks-security-group"
#   description = "allow inbound access from the ALB only"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     protocol        = "tcp"
#     from_port       = var.app_port
#     to_port         = var.app_port
#     security_groups = [aws_security_group.lb.id]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#       Name = "ecs_demo_terraform_course"
#   }
# }

# resource "aws_security_group" "rds_sg" {
#   name = "rds-sg"

#   description = "RDS (terraform-managed)"
#   vpc_id      = aws_vpc.main.id

#   # Only Postgres in
#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow all outbound traffic.
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }




resource "aws_db_instance" "db" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  skip_final_snapshot  = true
  # Set the secrets from AWS Secrets Manager
  username = var.db_username
  password =  random_password.master_password.result

  db_subnet_group_name = aws_db_subnet_group.subnet.id

  vpc_security_group_ids = [aws_security_group.lb.id]

  publicly_accessible = true

  depends_on = [
  random_password.master_password
]

}

resource "aws_secretsmanager_secret" "rds_creds" {
  name = "rds_creds"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_creds" {
  secret_id     = aws_secretsmanager_secret.rds_creds.id
  secret_string = <<EOF
{
  "username": "${var.db_username}",
  "password": "${random_password.master_password.result}",
  "engine": "postgres",
  "host": "${aws_db_instance.db.endpoint}",
  "port": ${aws_db_instance.db.port}
}
EOF

depends_on = [
  aws_db_instance.db,
  random_password.master_password
]
}