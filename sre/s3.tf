resource "aws_s3_bucket" "mimir" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name    = var.bucket_name
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "block" {
  bucket        = "${var.bucket_name}-block"
  force_destroy = true

  tags = {
    Name    = "${var.bucket_name}-block"
    Project = var.project_name
  }
}
resource "aws_s3_bucket" "ruler" {
  bucket        = "${var.bucket_name}-ruler"
  force_destroy = true

  tags = {
    Name    = "${var.bucket_name}-ruler"
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "alert" {
  bucket        = "${var.bucket_name}-alert"
  force_destroy = true

  tags = {
    Name    = "${var.bucket_name}-alert"
    Project = var.project_name
  }
}
