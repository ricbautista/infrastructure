resource "aws_route53_zone" "domain" {
  name = "${lookup(var.ops_dns_domain, var.environment)}"
  tags {
    Name        = "${var.environment}-domain"
    Environment = "${var.environment}"
  }
}

resource "aws_route53_record" "deployserver" {
  zone_id = "${aws_route53_zone.domain.id}"
  name = "deployserver"
  type = "A"
  ttl  = 60
  records = ["${aws_instance.deployserver.public_ip}"]
}

