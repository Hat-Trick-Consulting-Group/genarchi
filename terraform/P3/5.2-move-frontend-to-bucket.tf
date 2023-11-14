resource "aws_s3_object" "static_html" {
  bucket = aws_s3_bucket.tf-front_end_bucket.id
  key    = "index.html"
  source = "../../frontend/dist/index.html"
  content_type = "text/html"
  etag = filemd5("../../frontend/dist/index.html")

  depends_on = [null_resource.build_frontend, local_file.api_config]
}

resource "aws_s3_object" "vite_svg" {
  bucket = aws_s3_bucket.tf-front_end_bucket.id
  key    = "vite.svg"
  source = "../../frontend/dist/vite.svg"
  content_type = "text/html"
  etag = filemd5("../../frontend/dist/vite.svg")

  depends_on = [null_resource.build_frontend, local_file.api_config]
}

resource "aws_s3_object" "index_js" {
  for_each     = fileset(path.module, "../../frontend/dist/assets/*.{html,css,js,svg}")
  bucket       = aws_s3_bucket.tf-front_end_bucket.id
  key          = replace(each.value, "frontend/dist/", "")
  source       = each.value
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  etag         = filemd5(each.value)

  depends_on = [null_resource.build_frontend, local_file.api_config]
}

output "front_end_website_url" {
  description = "S3 hosting URL (HTTP)"
  value = "http://${aws_s3_bucket.tf-front_end_bucket.bucket}.s3-website.${var.AWS_REGION}.amazonaws.com"
}
