resource "aws_lambda_layer_version" "opencv" {
  filename   = "lambda/layers/opencv-layer-6da02046-8b00-4a76-8152-f28bba6495e2.zip"
  layer_name = "opencv4"

  compatible_runtimes = ["python3.6"]
}

resource "aws_iam_role" "iam_for_gatmauel_lambda" {
  name = "iam_for_gatmauel_lambda"

  assume_role_policy = <<EOF
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

resource "aws_iam_policy" "gatmauel" {
  name        = "gatmauel_lambda"
  description = "IAM policy for a lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "gatmauel" {
  role       = aws_iam_role.iam_for_gatmauel_lambda.name
  policy_arn = aws_iam_policy.gatmauel.arn
}

resource "aws_cloudwatch_log_group" "gatmauel" {
  name = "gatmauel_lambda"
  retention_in_days = 14
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_resize.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.gatmauel.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.gatmauel.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_resize.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "original/"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_lambda_function" "image_resize" {
  filename      = "lambda/image-resize-package.zip"
  function_name = "gatmauel-image-resize"
  role          = aws_iam_role.iam_for_gatmauel_lambda.arn
  handler       = "lambda_function.lambda_handler"

  runtime = "python3.6"

  layers = [aws_lambda_layer_version.opencv.arn]

  depends_on = [
    aws_iam_role_policy_attachment.gatmauel,
    aws_cloudwatch_log_group.gatmauel,
  ]

  memory_size = 512
}