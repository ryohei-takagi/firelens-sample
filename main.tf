resource "aws_ecs_cluster" "default" {
  name = "firelens-sample"
}

resource "aws_ecs_task_definition" "default" {
  container_definitions = data.template_file.default.rendered
  family = "firelens-sample"

  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn = aws_iam_role.app.arn
}

resource "aws_ecs_service" "default" {
  name = "firelens-sample"
  task_definition = aws_ecs_task_definition.default.arn

  cluster = aws_ecs_cluster.default.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    assign_public_ip = true

    subnets = [
      aws_subnet.private1.id,
      aws_subnet.private2.id,
    ]
  }
}

resource "aws_iam_role" "execution" {
  assume_role_policy = data.aws_iam_policy_document.execution.json
  name = "execution-role"
}

data "aws_iam_policy_document" "execution" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role = aws_iam_role.execution.name
}

resource "aws_iam_role" "app" {
  assume_role_policy = data.aws_iam_policy_document.app.json
  name = "app-role"
}

data "aws_iam_policy_document" "app" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "app1" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role = aws_iam_role.app.name
}

resource "aws_iam_role_policy_attachment" "app2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess"
  role = aws_iam_role.app.name
}

resource "aws_ecr_repository" "go" {
  name = "firelens-sample/go"
}

resource "aws_ecr_repository" "nginx" {
  name = "firelens-sample/nginx"
}

resource "aws_ecr_repository" "fluentbit" {
  name = "firelens-sample/fluentbit"
}

resource "aws_cloudwatch_log_group" "defult" {
  name = "/ecs/firelens-sample"
}