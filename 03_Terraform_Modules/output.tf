output "ec2_1_ip" {
  value = module.ec2_1.public_ip
}

output "s3_bucket_1_arn" {
  value = module.s3_1.bucket_arn
}
