module "python_packager" {
  source  = "./.."
  src_dir = "./src"
}

resource "aws_iam_role" "this" {
  name = "iam_for_lambda_python_packager"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF
}

resource "aws_lambda_function" "this" {
  description      = "Lambda for testing python package deployment with its dependencies"
  filename         = module.python_packager.package_path
  function_name    = "hash_generator"
  role             = aws_iam_role.this.arn
  handler          = "hashgen.handler" # hashgen.py -> handler(event, context)
  source_code_hash = module.python_packager.package_hash
  runtime          = "python3.9"
}
