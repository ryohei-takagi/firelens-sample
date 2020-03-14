variable "aws-account-id" {
  default = "{ Your AWS Account ID }"
}

data "template_file" "default" {
  template = <<EOF
[
  {
    "image": "${var.aws-account-id}.dkr.ecr.ap-northeast-1.amazonaws.com/firelens-sample/go:latest",
    "name": "go",
    "essential": false,
    "logConfiguration": {
      "logDriver": "awsfirelens"
    },
    "portMappings": [],
    "cpu": 64,
    "memoryReservation": 128,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": []
  },
  {
    "image": "${var.aws-account-id}.dkr.ecr.ap-northeast-1.amazonaws.com/firelens-sample/nginx:latest",
    "name": "nginx",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awsfirelens"
    },
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 64,
    "memoryReservation": 128,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": []
  },
  {
    "image": "${var.aws-account-id}.dkr.ecr.ap-northeast-1.amazonaws.com/firelens-sample/fluentbit:latest",
    "name": "log_router",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/firelens-sample",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "firelensConfiguration": {
      "type": "fluentbit",
      "options": {
        "config-file-type": "file",
        "config-file-value": "/fluent-bit/etc/fluent-bit_custom.conf"
      }
    },
    "portMappings": [],
    "cpu": 128,
    "memoryReservation": 256,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": [],
    "user": "0"
  }
]
EOF
}