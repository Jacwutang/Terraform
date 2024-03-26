output "name" {
    description = "s3-bucket-name"
    value = aws_s3_bucket.web.id
}

output "endpoint" {
    description = "s3 website endpoint"
    value = aws_s3_bucket_website_configuration.web.website_endpoint
}