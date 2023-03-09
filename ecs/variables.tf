# variables.tf

variable "aws_region" {
  description = "The AWS region resources are created"
  default     = "us-west-2"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "EcsLabTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "xccxxc.dkr.ecr.us-west-2.amazonaws.com/ecr-repo-for-tf-lab:v2"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "db_port" {
  description = "DB port"
  default     = 5432
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 3
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "db_username" {
  description = "rds user name"
  default     = "db_user"
}

variable "env" {
  description = "Targeted Depolyment environment"
  default     = "dev"
}

variable "artifacts_bucket_name" {
  description = "S3 Bucket for storing artifacts"
  default     = "nodeapp-new"
}


variable "nodejs_project_repository_name" {
  description = "Nodejs Project Repository name to connect to"
  default     = "nodeapp"
}
variable "nodejs_project_repository_branch" {
  description = "Nodejs Project Repository branch to connect to"
  default     = "master"
}