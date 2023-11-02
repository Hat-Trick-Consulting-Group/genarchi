resource "aws_dynamodb_table" "clients" {
  name             = "clients"
  hash_key         = "id"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}