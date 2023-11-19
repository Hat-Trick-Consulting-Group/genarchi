resource "aws_cloudfront_origin_access_identity" "tf_cloudfront_oai" {
  comment = "tf_cloudfront"
}

resource "aws_cloudfront_distribution" "tf_cloudfront" {
  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.tf_front_end_bucket.bucket
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl     = 0
    default_ttl = 5 * 60
    max_ttl     = 60 * 60

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name = aws_s3_bucket.tf_front_end_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.tf_front_end_bucket.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.tf_cloudfront_oai.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [aws_s3_bucket.tf_front_end_bucket]
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.tf_cloudfront.domain_name
}