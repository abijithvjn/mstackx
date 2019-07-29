module "route_53_private_zone"
{
 source = "../../modules/route53/"
 vpc_id = "${module.main_vpc.vpc_id}"
 private_zone_name = "internal"
}
