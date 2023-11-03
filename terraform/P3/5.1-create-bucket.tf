resource "aws_s3_bucket" "tf-front_end_bucket" {
  bucket = "hat-trick-tf-front-end-bucket"

  website {
    index_document = "index.html"  # Specify the main entry point for your website
    error_document = "index.html"  # Optional: Specify a custom error page
  }
}

resource "aws_s3_bucket_ownership_controls" "tf-front_end_bucket" {
  bucket = aws_s3_bucket.tf-front_end_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "tf-front_end_bucket" {
  bucket = aws_s3_bucket.tf-front_end_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "tf-front_end_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.tf-front_end_bucket,
    aws_s3_bucket_public_access_block.tf-front_end_bucket,
  ]

  bucket = aws_s3_bucket.tf-front_end_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "tf-front_end_bucket_policy" {
  bucket = aws_s3_bucket.tf-front_end_bucket.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "PublicReadGetObject",
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.tf-front_end_bucket.id}/*"
        }
      ]
    }
  )
}