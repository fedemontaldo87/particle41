output "security_group" {
  value       = aws_security_group.services.id
  description = "Id of security Group"
}

output "main" {
  value       = aws_vpc.main.id
  description = "Id of VPC"
}

output "subnet_public1" {
  value       = aws_subnet.public_1.id
  description = "Id of subnet public 1"
}

output "subnet_public2" {
  value       = aws_subnet.public_2.id
  description = "Id of subnet public 2"
}

output "subnet_private1" {
  value       = aws_subnet.private_1.id
  description = "Id of subnet private 1"
}

output "subnet_private2" {
  value       = aws_subnet.private_2.id
  description = "Id of subnet private 2"
}

output "key_name" {
  value       = aws_key_pair.my_key.key_name
  description = "Name of key pair RSA"
}

output "bucket_domain_name" {
  value       = join("", aws_s3_bucket.terraform-state-particle41.*.bucket_domain_name)
  description = "FQDN of bucket"
}

output "bucket_id" {
  value       = join("", aws_s3_bucket.terraform-state-particle41.*.id)
  description = "Bucket Name (aka ID)"
}

output "bucket_arn" {
  value       = join("", aws_s3_bucket.terraform-state-particle41.*.arn)
  description = "Bucket ARN"
}