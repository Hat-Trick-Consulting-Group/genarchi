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

resource "local_file" "api_config" {
  filename = "../../frontend/.env.production"
  content  = <<-EOT
    VITE_API_URL = "${aws_apigatewayv2_stage.prod.invoke_url}"
  EOT
}

resource "null_resource" "npm_build" {
  triggers = {
    build_trigger = "../../frontend/.env.production"
  }

  provisioner "local-exec" {
    command = "npm run build"
    
    working_dir = "../../frontend/"
  }
}

resource "aws_s3_object" "static_html" {
  bucket = aws_s3_bucket.tf-front_end_bucket.id
  key    = "index.html"
  source = "../../frontend/dist/index.html"
  content_type = "text/html"
  etag = filemd5("../../frontend/dist/index.html")
}

resource "aws_s3_object" "vite_svg" {
  bucket = aws_s3_bucket.tf-front_end_bucket.id
  key    = "vite.svg"
  source = "../../frontend/dist/vite.svg"
  content_type = "text/html"
  etag = filemd5("../../frontend/dist/vite.svg")
}

resource "aws_s3_object" "index_js" {
  for_each     = fileset(path.module, "../../frontend/dist/assets/*.{html,css,js,svg}")
  bucket       = aws_s3_bucket.tf-front_end_bucket.id
  key          = replace(each.value, "frontend/dist/", "")
  source       = each.value
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  etag         = filemd5(each.value)
}

output "front_end_website_url" {
  description = "S3 hosting URL (HTTP)"
  value = "http://${aws_s3_bucket.tf-front_end_bucket.bucket}.s3-website-${var.AWS_REGION}.amazonaws.com"
}
