resource "aws_instance" "deployserver" {
  ami                         = "ami-d8c21dba"
  availability_zone           = "${var.region}a"
  instance_type               = "${lookup(var.deployserver_instance_type, var.environment)}"
  security_groups             = ["${var.environment}-common"]
  key_name                    = "training-${var.environment}"
  disable_api_termination     = "false"
  ebs_optimized               = "${lookup(var.ebs_optimized, var.environment)}"
  monitoring                  = "true"

  root_block_device {
    volume_size = "${lookup(var.deployserver_root_disk_size, var.environment)}"
  }
  tags {
    Name         = "${var.environment}-deployserver"
    Environment  = "${var.environment}-ricardo"
  }
  connection {
    user                = "centos"
    host                = "${self.public_ip}"
    private_key         = "${file("~/.ssh/id_rsa-aws")}"
  }
  provisioner "file" {
    source      = "../provision-scripts/bootstrap-ec2.sh" 
    destination = "/tmp/bootstrap-ec2.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/bootstrap-ec2.sh -h deployserver.${var.environment}.localdomain -e ${var.environment}",
    ]
  }
}

output "deployserver_public_ip_address" {
    value = "${aws_instance.deployserver.public_ip}"
}
