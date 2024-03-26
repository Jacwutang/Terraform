output name {
    description = "s3 bucket name"
    value = module.website_s3_bucket.name
}

output endpoint {
    description = "s3 website endpoint"
    value = module.website_s3_bucket.endpoint
}

output "module_path" {
  value = module.website_s3_bucket.module_path
}