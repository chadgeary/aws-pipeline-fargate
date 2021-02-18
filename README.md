# Overview
Terraform full stack container service in AWS.

- Dockerfile and buildspec.yml define the container
- CodePipe fetches via S3 and passes to CodeBuild
- CodeBuild creates the container image and pushes to ECR (Container Repository)
- ECS Task builds `n` containers from ECR image
- ECS Service attaches containers to Load Balancer
