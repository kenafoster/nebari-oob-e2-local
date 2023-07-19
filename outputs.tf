output "nebari_ec2_public_ip" {
  description = "Public IP of sandbox EC2"
  value       = aws_eip.nebari_sandbox_eip.address
}