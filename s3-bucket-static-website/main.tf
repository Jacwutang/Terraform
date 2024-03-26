provider "aws" {
    region = "us-east-1"
}

module "website_s3_bucket" {
    source = "./modules/s3-bucket"
    bucket_name = "my-tf-bucket-jackwu350"
}