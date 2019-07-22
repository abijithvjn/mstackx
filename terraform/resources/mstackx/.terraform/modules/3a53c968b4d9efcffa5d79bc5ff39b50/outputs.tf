output "private_ip" { value = ["${aws_instance.app_ec2.*.private_ip}"] }
output "instance_id" { value = ["${aws_instance.app_ec2.*.id}"] }
