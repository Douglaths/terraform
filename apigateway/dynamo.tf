resource "aws_dynamodb_table" "http_crud_tutorial_items" {
  name           = "http-crud-tutorial-items"
  hash_key       = "id"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}