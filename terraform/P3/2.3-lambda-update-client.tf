
resource "aws_iam_role" "tf-update-client_lambda_exec" {
  name = "tf-update-client-lambda"

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

resource "aws_iam_role_policy_attachment" "tf-update-client_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.tf-update-client_lambda_exec.name
}

resource "aws_iam_role_policy_attachment" "tf-update-client_cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.tf-update-client_lambda_exec.name
}

resource "aws_iam_role_policy_attachment" "tf-update-client_dynamodb_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.tf-update-client_lambda_exec.name
}

resource "aws_lambda_function" "tf-update-client" {
  function_name = "tf-update-client"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_tf-update-client.key

  runtime = "nodejs18.x"
  handler = "update-client.handler"

  role = aws_iam_role.tf-update-client_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "tf-update-client" {
  name = "/aws/lambda/${aws_lambda_function.tf-update-client.function_name}"

  retention_in_days = 1
}

resource "aws_s3_object" "lambda_tf-update-client" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "tf-update-client.zip"
  source = "lambdas/tf-update-client.zip"

  etag = filemd5("lambdas/tf-update-client.zip")
}