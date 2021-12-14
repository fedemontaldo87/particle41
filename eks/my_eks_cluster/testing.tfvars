# Provider config
profile         = "default"   # AWS profile https://amzn.to/2IgHGCs
region          = "us-east-1" # See regions of AWS https://amzn.to/3khGP21
environment     = "testing"
address_allowed = "192.168.0.3" # My house public IP Address

# Get AWS ACCOUNT-ID with command:
# aws sts get-caller-identity --query Account --output text --profile PROFILE_NAME_AWS
# Reference: https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html

# Networking
subnets = ["subnet-01f32e14cb098aace", "subnet-063767052d11701c4", "subnet-019e61fd308a2e077", "subnet-0db9568ebcf4beeee"]
vpc_id  = "vpc-065a2d9f904d59558"

# EKS
cluster_name                             = "my_eks_cluster"
cluster_version                          = "1.21"
lt_name                                  = "mycluster-ec2"
autoscaling_enabled                      = true
# https://aws.amazon.com/ec2/pricing/on-demand/
override_instance_types                  = ["t3.micro", "t3a.micro"]
on_demand_percentage_above_base_capacity = 50
asg_min_size                             = 3
asg_max_size                             = 20
asg_desired_capacity                     = 3
root_volume_size                         = 20
aws_key_name                             = "aws-testing"
public_ip                                = false
cluster_endpoint_public_access           = true
cluster_endpoint_public_access_cidrs     = ["0.0.0.0/0"]
cluster_endpoint_private_access          = true
cluster_endpoint_private_access_cidrs    = ["0.0.0.0/0"]
kubelet_extra_args                       = "--node-labels=node.kubernetes.io/lifecycle=spot"
suspended_processes                      = ["AZRebalance"]
cluster_enabled_log_types                = ["api", "audit"]
cluster_log_retention_in_days            = "7"
workers_additional_policies              = [
  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
  "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
  "arn:aws:iam::415801906357:policy/eks_cluster_autoscaler",
  "arn:aws:iam::415801906357:policy/aws_lb_controller"
]

worker_additional_security_group_ids     = ["sg-0746d70f0b6ea542b"]

map_roles = [  
  {   
    rolearn  = "arn:aws:iam::415801906357:role/admin"
    username = "gitlab-admin"
    groups   = ["system:masters"]
  },
]

map_users = [
  {
    userarn  = "arn:aws:iam::415801906357:user/gitlab-admin"
    username = "gitlab-admin"
    groups   = ["system:masters"]
  },
]

# General
tags = {
  Scost                                             = "testing",
  Terraform                                         = "true",
  Environment                                       = "testing",
  "k8s.io/cluster-autoscaler/enabled"               = "true",
  "k8s.io/cluster-autoscaler/my_eks_cluster" = "owned"
  "kubernetes.io/cluster/my_eks_cluster"     = "owned"
}