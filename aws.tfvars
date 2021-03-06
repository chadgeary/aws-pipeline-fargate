# Region to create/deploy resources
aws_region = "us-east-1"

# A label prefixed to various components' names
# A unique suffix is randomly generated
# e.g. 'alexa1-lambdafunction-12345'
aws_prefix = "alexa1"

# The AWSCLI profile to use, generally default
aws_profile = "default"

# A non-root IAM user for managing/owning KMS keys
kms_manager = "some_user"

# networking
vpc_cidr = "10.10.20.0/24"
subnetA_cidr = "10.10.20.0/26"
subnetB_cidr = "10.10.20.64/26"
subnetC_cidr = "10.10.20.128/26"
subnetD_cidr = "10.10.20.192/26"

# service
service_port = 53
service_protocol = "TCP"
service_count = 1

# service clients - a list of subnets allowed to reach service port/protocol
client_cidrs = ["127.0.0.1/32","127.0.0.1/32"]
