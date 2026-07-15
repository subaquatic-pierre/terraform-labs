resource "aws_s3_bucket" "stackops" {
  bucket = "${var.project_name}-bucket"

  tags = {
    Name = "${var.project_name}-bucket"
  }
}

resource "aws_s3_bucket_versioning" "stackops" {
  bucket = aws_s3_bucket.stackops.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "stackops" {
  bucket = aws_s3_bucket.stackops.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "stackops" {
  bucket = aws_s3_bucket.stackops.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# resource "aws_s3_bucket_policy" "stackops" {
#   bucket = aws_s3_bucket.stackops.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "PublicReadGetObject"
#         Effect    = "Allow"
#         Principal = "*"
#         Action = [
#           "s3:GetObject"
#         ]
#         Resource = [
#           "${aws_s3_bucket.stackops.arn}/*"
#         ]
#       }
#     ]
#   })

#   depends_on = [
#     aws_s3_bucket_public_access_block.stackops
#   ]
# }

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.stackops.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFront"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action = [
          "s3:GetObject"
        ]

        Resource = "${aws_s3_bucket.stackops.arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.site.arn
          }
        }
      }
    ]
  })
}
