output "nebari_ec2_public_ip" {
  description = "Public IP of sandbox EC2 - NOT an elastic IP"
  value       = aws_instance.nebari_sandbox_ec2.public_ip
}