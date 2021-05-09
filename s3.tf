resource "aws_s3_bucket" "gatmauel" {
  bucket = "gatmauel-devops"
  acl    = "private"

  lifecycle_rule {
    id      = "original"
    prefix  = "original/"
    enabled = true

    expiration {
      days = 3
    }

    abort_incomplete_multipart_upload_days = 3
  }
}

resource "aws_s3_bucket_policy" "allow_cf" {
  bucket = aws_s3_bucket.gatmauel.id

  policy = jsonencode({
    Version = "2008-10-17",
    Id = "PolicyForCloudFrontPrivateContent",
    Statement = [
      {
        Sid = "1",
        Effect = "Allow",
        Principal = {
           AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.gatmauel.id}"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.gatmauel.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "pirvate" {
  bucket = aws_s3_bucket.gatmauel.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "menu" {
    bucket = aws_s3_bucket.gatmauel.id
    acl    = "private"
    content_type = "image/jpeg"

    for_each = fileset("img/menu", "*")
    key    = "menu/${each.value}"
    source = "img/menu/${each.value}"
}

resource "aws_s3_bucket_object" "original" {
    bucket = aws_s3_bucket.gatmauel.id
    acl    = "private"
    key    = "original/"
    source = "/dev/null"
}

resource "aws_s3_bucket_object" "resized" {
    bucket = aws_s3_bucket.gatmauel.id
    acl    = "private"
    key    = "resized/"
    source = "/dev/null"
}

resource "aws_s3_bucket_object" "view" {
    bucket = aws_s3_bucket.gatmauel.id
    acl    = "private"
    content_type = "image/jpeg"

    for_each = fileset("img/view", "*")
    key    = "view/${each.value}"
    source = "img/view/${each.value}"
}


