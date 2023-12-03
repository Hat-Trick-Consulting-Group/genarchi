
resource "aws_iam_role" "tf-health_lambda_exec" {
  name = "tf-health-lambda"

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

resource "aws_iam_role_policy_attachment" "tf-health_lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.tf-health_lambda_exec.name
}

resource "aws_iam_role_policy_attachment" "tf-health_lambda_cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.tf-health_lambda_exec.name
}

resource "aws_iam_role_policy_attachment" "tf-health_lambda_dynamodb_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.tf-health_lambda_exec.name
}

resource "aws_lambda_function" "tf-health" {
  function_name = "tf-health"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_tf-health.key

  runtime = "nodejs18.x"
  handler = "health.handler"

  role = aws_iam_role.tf-health_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "tf-health" {
  name = "/aws/lambda/${aws_lambda_function.tf-health.function_name}"

  retention_in_days = 1
}

resource "aws_s3_object" "lambda_tf-health" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "tf-health.zip"
  source = "lambdas/tf-health.zip"

  etag = filemd5("lambdas/tf-health.zip")
}