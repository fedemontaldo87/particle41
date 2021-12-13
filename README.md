# particle41

<!-- TOC -->
- [terraform local k8s](#terraform local k8s)
- [terraform eks](#terraform eks)
- [Prerequisites](#Prerequisites)
- [Understanding the code](#Understanding the code)
- [Creating VPC, Bucket S3 and table in DynamoDB](#Creating VPC, Bucket S3 and table in DynamoDB)
- [Creating the EKS cluster](#Creating the EKS cluster)
- [Accessing the EKS cluster](#Accessing the EKS cluster)
- [Troubleshooting EKS](#Troubleshooting EKS)
- [Documentation](#Documentation)
- [Removing EKS cluster](#Removing EKS cluster)

<!-- TOC -->

# terraform local k8s

Under eks/eks_local

A README.md with the necesary instructtions will be

# teraform eks
# Prerequisites

To perform the steps in this code you need to use some GNU / Linux distribution, as the commands have not been tested on MS Windows or MacOS.

You must have an AWS account and have the AdministratorAccess and PowerUserAccess policies directly associated with your account or associated with a role (group of policies) that you can use. These policies contain all necessary permissions to manage AWS resources.

You must have aws-cli version 1.16.x or higher installed. 

You must have installed kubectl version 1.18.x or higher. 

Terraform version 0.12.x must be installed. Install by following the steps in this tutorial:

For this a VPC (Virtual Private Cloud) network will be created for use in the Kubernetes cluster and an AWS-S3 bucket and a table in the AWS-DynamoDB service will also be created to store the terraform state (information on the infrastructure status to be created by Terraform).

# Understanding the code

The my_eks_vpc directory contains the necessary code to create the network infrastructure required to create the EKS cluster.

The name of each file is very intuitive and the code inside each one describes the functionality or resources to be created by Terraform. Example: The vpc.tf file contains instructions for managing the AWS VPC resource and subnets. The policies.tf file creates the necessary policies in the AWS-IAM service.

The testing.tfvars file stands out, as it contains the values of some important parameters that can be customized according to your need or preference. The outputs.tf file contains the code snippet that will display some information about the resources managed by Terraform. This information will be used to customize the mycluster-eks/testing.tfvars file.

The README.md file contains instructions and commands to be executed to create the network infrastructure.

The mycluster-eks directory contains the necessary code to create the EKS cluster.

The name of each file is also intuitive and the code inside each one describes the functionality or resources to be created by Terraform. Example: The file eks.tf contains the instructions for managing the cluster.

The files testing.tfvars and backend.tf also stand out, including the values of some important parameters that can be customized according to your needs.

The README.md file contains the instructions and commands to be executed to create the cluster.

Before executing the commands in the following section, open each file and try to understand what each one does. Consult the Terraform and AWS documentation to better understand what each feature is and their use.

# Creating VPC, Bucket S3 and table in DynamoDB

In the eks/networking-eks/testing.tfvars file we can access the region parameter, which indicates that the infrastructure will be created in the Virginia region (us-east-1), using the default profile (which is the same name in the ~/.aws/credentials file and which must contain the registered access key and secret key to access the AWS API).

If it doesn’t exist, create an asymmetric public-private key pair with the following command:

sudo ssh-keygen -t rsa -b 2048 -v -f /home/aws-testing.pem

Do not enter a password when creating the key pair, just press ENTER. The public key will be created in the following path: /home/aws-testing.pem.pub and will be registered on AWS under the name aws-testing. This public key will be associated with the EC2 instances during the cluster creation and you will be able to access via SSH in the future using the private key that is in /home/aws-testing.pem.

This information was registered in the file eks/networking-eks/testing.tfvars in the parameters aws_public_key_path and aws_key_name.

Another important information to be customized in this same file is the address_allowed parameter, which contains the public IP address and netmask that can access the network on which the cluster will be created. By default, external access is blocked.

The name of the S3 bucket that will store the terraform state is being defined in the bucket_name parameter. The buckets name on AWS is global and there cannot be another bucket with the same name, even in different accounts. You are likely to encounter an error while running Terraform, notifying that the bucket already exists and will not be created. The solution is to define another name. This information will be used later to customize the configuration of the code that will create the cluster.

The table name in DynamoDB that will be used in conjunction with bucket S3 is used to prevent more than one person from changing the terraform state simultaneously, it is defined in the parameter dynamodb_table_name. This information will also be used later to customize the configuration of the code that will create the cluster.

Create the network infrastructure (VPC, subnets, security group, route table, NAT Gateway, Internet Gateway), policies, bucket, and table in DynamoDB with the following commands:

cd ~/eks/my_eks_vpc

terraform init

terraform validate

terraform workspace new testing

terraform workspace list

terraform workspace select testing

terraform plan -var-file testing.tfvars

terraform apply -var-file testing.tfvars

The creation of the network infrastructure can take 5 minutes or more.

View the infrastructure information created with the following commands:

terraform output

The following information will be used in the next section to configure some parameters in the file eks/my_els_cluster-eks/testing.tfvars

bucket_id

key_name

security_group

subnet_private1
subnet_private2
subnet_public1
subnet_public_2
vpc1

# Creating the EKS cluster

Edit the open-tools/terraform/eks/mycluster-eks/backend.tf file. Based on the information used in the previous section, change the following parameters:

bucket: enter the bucket name created previously. Example: “my-terraform-remote-state-01“;

dynamodb_table: enter the name of the table created in DynamoDB. Example: “my-terraform-state-lock-dynamo”;

region: enter the name of the AWS region used to create the cluster, it must be the same where the network infrastructure was created. Example: “us-east-1“;

profile: enter the name of the AWS profile with the API access credentials configured in the ~ /.aws/credentials file. It must be the same one used to create the network infrastructure. Example: “default“.

Edit the my_eks_clsuter/testing.tfvars file. Based on the information used in the previous section, change the following parameters:

profile: enter the name of the AWS profile with the API access credentials configured in the ~ /.aws/credentials file. It must be the same one used to create the network infrastructure. Example: “default“.

region: enter the name of the AWS region used to create the cluster, it must be the same in which the network infrastructure was created. Example: “us-east-1“;

address_allowed: the public IP address and netmask that can access the network where the cluster will be created. Example: “201.82.34.213/32”.

subnets: must contain the list with the IDs of subnet_private1 and subnet_public_1, shown at the end of the previous section. Example: [“subnet-06dd40e8124e67325”, “subnet-098580d73a131193c”];

vpc_id: must contain the vpc1 ID shown at the end of the previous section. Example: “vpc-068004d30dd97a13b”;

cluster_name: contains the cluster name. The name entered here must be the same at the end of the tags “k8s.io/cluster-autoscaler/mycluster-eks-testing” and “kubernetes.io/cluster/mycluster-eks-testing”, otherwise it will not be possible to enable cluster autoscaling. Example: “mycluster-eks-testing”;

cluster_version: contains the EKS version to be used in the cluster. Example: “1.21”;

override_instance_types: list with EC2 instance types to be used in the cluster. Example: [“t3.micro”, “t3a.micro”];

on_demand_percentage_above_base_capacity: percentage of on-demand instances to be used in the cluster. The remaining percentage will be of spot instances (cheaper, but ephemeral). Example: 50;

asg_min_size: minimum number of instances in the cluster. Example: 2;

asg_max_size: maximum number of instances in the cluster. Example: 20;

asg_desired_capacity: desired number of instances in the cluster. Example: 2;

root_volume_size: GB size of the disk to be used in each instance. Example: 20;

aws_key_name: name of the public key registered in the previous section to be used by the EC2 instances of the cluster. Example: “aws-testing”;

worker_additional_security_group_ids: list containing the security group ID created in the previous section that will be associated with the cluster. Example: [“sg-0bc21eaa5b3a26146”];

Get your AWS account ID with the following command:

aws sts get-caller-identity –query Account –output text –profile PROFILE_NAME_AWS

Where:

PROFILE_NAME_AWS: is the name of the AWS profile defined in the file configuration ~/.aws/credentials

Edit again the file open-tools/terraform/eks/mycluster-eks/testing.tfvars.

And change all occurrences of ID 255686512659 by your account ID. Also change the instance of role adsoft by the name registered in your account (if any) and change the instance of the user aeciopires by your AWS username. This is very important because the users and roles informed in the map_roles and map_users parameters will be the only admins in the EKS cluster.

Finally, create the EKS cluster with the following commands:

cd ~eks/mycluster-eks

terraform init

terraform validate

terraform workspace new testing

terraform workspace list

terraform workspace select testing

terraform plan -var-file testing.tfvars

terraform apply -var-file testing.tfvars

Note: The cluster creation may take 15 minutes or more.

View the information for the created cluster with the following commands:

terraform output

terraform show

# Accessing the EKS cluster

Run the following command to access the cluster.

aws eks –region REGION_NAME update-kubeconfig –name CLUSTER_NAME –profile PROFILE_NAME_AWS

Where:

REGION_NAME: is the name of the region where the cluster was created.

CLUSTER_NAME: is the name of the cluster.

PROFILE_NAME_AWS: is the name of the AWS profile defined in the file configuration ~/.aws/credentials.

Example:

aws eks –region us-east-1 update-kubeconfig –name mycluster –profile default

To test access, check the pods status with the following command.

kubectl get pods –all-namespaces

 
# Troubleshooting EKS
Information on troubleshooting EKS is available at the following links:

https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html

https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting_iam.html

https://aws.amazon.com/pt/premiumsupport/knowledge-center/eks-api-server-unauthorized-error

https://aws.amazon.com/premiumsupport/knowledge-center, section Amazon Elastic Container Service for Kubernetes (Amazon EKS)

# Documentation
The complete documentation of the resources used in this tutorial are available at the following links. Use this information to deepen your daily learning.

Terraform: https://www.terraform.io/docs

Provider AWS: https://www.terraform.io/docs/providers/aws

Terraform module for EKS: https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/13.0.0

AWS-VPC: https://docs.aws.amazon.com/vpc/latest/userguide

AWS-S3: https://docs.aws.amazon.com/AmazonS3/latest/gsg

AWS-DynamoDB: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide

AWS-EKS: https://docs.aws.amazon.com/eks/latest/userguide

# Removing EKS cluster
Run the following commands to remove the EKS cluster:

cd ~/eks/mycluster-eks

terraform workspace select testing

terraform destroy -var-file testing.tfvars

Removing the cluster can take 5 minutes or more.

Removing VPC and S3 buckets
Run the following commands to remove the network infrastructure created:

cd ~/eks/my_eks_vpc

terraform workspace select testing

terraform destroy -var-file testing.tfvars

Removing the network infrastructure can take 5 minutes or more.

If at the end of the resource’s removal, you see the following error, access the AWS web console and the URL: https://s3.console.aws.amazon.com/s3/. Locate the bucket name and check the checkbox to the left of the name. Then click on the empty button. Follow the instructions to empty the bucket.

Error: error deleting S3 Bucket …

BucketNotEmpty: The bucket you tried to delete is not empty. You must delete all versions in the bucket.

After that, edit the file open-tools/terraform/eks/networkin-eks/bucket.tf and change the parameters:

Before:

  versioning {

 enabled = true

   }

   lifecycle {

   prevent_destroy = true

  }

After:

 force_destroy = true

  versioning {

 enabled = false

  }

  lifecycle {

  prevent_destroy = false

  }

Again, run the following commands to remove the bucket:

terraform destroy -var-file testing.tfvars

This is necessary because the bucket stores the terraform state and, in a normal situation in the production environment, the bucket is not expected to be removed to avoid losing track of changes in the environment using Terraform.
