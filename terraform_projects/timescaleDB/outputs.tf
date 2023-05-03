output "timescaledb_sg_id" {
  value = aws_security_group.timescaledb_sg.id
}

output "eip_id" {
  value = aws_eip.timescaledb_eip.id
}

output "eip_public_ip" {
  value = aws_eip.timescaledb_eip.public_ip
}
