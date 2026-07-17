resource "aws_s3_bucket" "mimir" {
  bucket        = "${var.bucket_name_prefix}-mimir"
  force_destroy = true

  tags = {
    Name    = "${var.bucket_name_prefix}-mimir"
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "mimir_block" {
  bucket        = "${var.bucket_name_prefix}-mimir-block"
  force_destroy = true

  tags = {
    Name    = "${var.bucket_name_prefix}-mimir-block"
    Project = var.project_name
  }
}
resource "aws_s3_bucket" "mimir_ruler" {
  bucket        = "${var.bucket_name_prefix}-mimir-ruler"
  force_destroy = true

  tags = {
    Name    = "${var.bucket_name_prefix}-mimir-ruler"
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "mimir_alert" {
  bucket        = "${var.bucket_name_prefix}-mimir-alert"
  force_destroy = true

  tags = {
    Name    = "${var.bucket_name_prefix}-mimir-alert"
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "loki_chunks" {
  bucket        = "${var.bucket_name_prefix}-loki-chunks"
  force_destroy = true

  tags = {
    Name    = "${var.bucket_name_prefix}-loki-chunks"
    Project = var.project_name
  }
}

resource "aws_s3_bucket" "loki_ruler" {
  bucket        = "${var.bucket_name_prefix}-loki-ruler"
  force_destroy = true

  tags = {
    Name    = "${var.bucket_name_prefix}-loki-ruler"
    Project = var.project_name
  }
}
