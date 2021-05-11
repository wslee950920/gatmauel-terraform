locals {
  s3_origin_id = "gatmauelS3Origin"
}

data "aws_cloudfront_origin_request_policy" "this" {
  name = "Managed-CORS-S3Origin"
}

data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_origin_access_identity" "gatmauel" {
  comment = "gatmauel s3 origin identity"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name = aws_s3_bucket.gatmauel.bucket_regional_domain_name
        origin_id   = local.s3_origin_id

        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.gatmauel.cloudfront_access_identity_path
        }
    }

    enabled = true
    is_ipv6_enabled = true

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        viewer_protocol_policy = "allow-all"

        cache_policy_id = data.aws_cloudfront_cache_policy.this.id
    }

    price_class = "PriceClass_200"

    restrictions {
        geo_restriction {
            restriction_type = "whitelist"
            locations        = ["KR"]
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}