
resource "aws_iam_role" "tf-add-client_lambda_exec" {
  name = "tf-add-client-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "add-client_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.tf-add-client_lambda_exec.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.tf-add-client_lambda_exec.name
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.tf-add-client_lambda_exec.name
}

resource "aws_lambda_function" "tf-add-client" {
  function_name = "tf-add-client"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_tf-add-client.key

  runtime = "nodejs18.x"
  handler = "function.handler"

  source_code_hash = data.archive_file.lambda_tf-add-client.output_base64sha256

  role = aws_iam_role.tf-add-client_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "tf-add-client" {
  name = "/aws/lambda/${aws_lambda_function.tf-add-client.function_name}"

  retention_in_days = 1
}

data "archive_file" "lambda_tf-add-client" {
  type = "zip"

  source_dir  = "${path.module}/lambdas/tf-add-client"
  output_path = "${path.module}/lambdas/tf-add-client.zip"
}

resource "aws_s3_object" "lambda_tf-add-client" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "tf-add-client.zip"
  source = data.archive_file.lambda_tf-add-client.output_path

  etag = filemd5(data.archive_file.lambda_tf-add-client.output_path)
}