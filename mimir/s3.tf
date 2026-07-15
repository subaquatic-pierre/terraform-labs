resource "aws_s3_bucket" "mimir" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name = "mimir-local"
  }
}


resource "aws_s3_bucket_versioning" "mimir" {
  bucket = aws_s3_bucket.mimir.id

  versioning_configuration {
    status = "Disabled"
  }
}
