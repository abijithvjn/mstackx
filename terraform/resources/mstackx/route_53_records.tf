resource "aws_route53_record" "private" {
  zone_id = "${module.route_53_private_zone.private_zone_id}"
  name    = "es"
  type    = "A"
  ttl     = "300"
  records = ["${module.elasticsearch.private_ip}"]
}
