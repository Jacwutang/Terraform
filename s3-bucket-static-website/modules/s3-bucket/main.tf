resource "aws_s3_bucket" "web" {
    bucket = var.bucket_name
    force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "web" {
    bucket = aws_s3_bucket.web.id
    
    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }
}

resource "aws_s3_bucket_public_access_block" "allow_access" {
    bucket = aws_s3_bucket.web.id
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false

}

resource "aws_s3_bucket_policy" "allow_access" {
    bucket = aws_s3_bucket.web.id
    policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
    statement {

        sid = "Allow Access"

        principals {
            type = "*"
            identifiers = ["*"]
        }

        actions = [
            "s3:*"
        ]

        resources = [
            "arn:aws:s3:::${aws_s3_bucket.web.id}/*"
        ]
    }
}

##### will upload all the files present under HTML folder to the S3 bucket #####
resource "aws_s3_object" "upload" {
  for_each      = fileset("${path.module}/html/", "*")
  bucket        = aws_s3_bucket.web.id
  key           = each.value
  source        = "${path.module}/html/${each.value}"
  #etag          = filemd5("${path.module}/html/${each.value}")
  content_type  = "text/html"
}