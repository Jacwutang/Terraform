output "name" {
    description = "s3-bucket-name"
    value = aws_s3_bucket.web.id
}