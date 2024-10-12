resource "aws_iam_role" "lambda_role" {
  name = "http-crud-tutorial-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

data "template_file" "product_lambda_policy" {
  template = "${file("${path.module}/politica.json")}"
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  path        = "/"
  description = "IAM policy for lambda functions"
  policy      = data.template_file.product_lambda_policy.rendered
}

resource "aws_iam_policy_attachment" "lambda_dynamodb_policy" {
  name       = "lambda-dynamodb-policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/funcion_lambda.py"
  output_path = "funcion_lambda.zip"
}

resource "aws_lambda_function" "http_crud_tutorial_function" {
  function_name = "http-crud-tutorial-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "funcion_lambda.lambda_handler"
  runtime       = "python3.12"

  filename         = "funcion_lambda.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.http_crud_tutorial_items.name
    }
  }
}