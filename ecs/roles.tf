# ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }

  # statement {
  #   effect = "Allow"
  #   actions = ["secretsmanager:GetSecretValue"]
  #   resources = ["${aws_secretsmanager_secret.database_password_secret.arn}"]
  # }

  # statement {
  #   sid = "AllowPullECR"
  #   effect = "Allow"
  #   actions = [
  #               "ecr:GetDownloadUrlForLayer",
  #               "ecr:BatchGetImage",
  #               "ecr:BatchCheckLayerAvailability"
  #           ]

  #   principals {
  #     type        = "Service"
  #     identifiers = ["ecs-tasks.amazonaws.com"]
  #   }
  # }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json

}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role_policy" "password_policy_secretsmanager" {
  name = "password-policy-secretsmanager"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Effect": "Allow",
        "Resource": [
          "${aws_secretsmanager_secret.rds_creds.arn}"
        ]
      }
    ]
  }
  EOF
}