[
  {
    "name": "${aws_prefix}-container-${aws_suffix}",
    "image": "${aws_repo_url}:latest",
    "cpu": 1,
    "memory": 128,
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${service_port},
        "hostPort": ${service_port}
      }
    ]
  }
]
