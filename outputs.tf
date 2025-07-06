output "tenant_url" {
  value = "https://${module.alb.alb_dns_name}"
}