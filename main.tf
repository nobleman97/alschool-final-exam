# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

resource "aws_iam_user" "kops" {
  name = "kops"
  path = "/"
}

resource "aws_iam_user_policy" "kops_user" {
  name = "kops_user"
  user = aws_iam_user.kops.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:*",
          "route53:*",
          "s3:*",
          "iam:*",
          "vpc:*",
          "sqs:*",
          "events:*",
          "autoscaling:*",
          "elasticloadbalancing:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}


resource "aws_iam_access_key" "kops" {
  user = aws_iam_user.kops.id
}

resource "aws_route53_zone" "nobleman_me" {
  name = "davido.live"
}

resource "aws_route53_zone" "kops_nobleman_me" {
  name = "kops.davido.live"
}

resource "aws_route53_record" "dev-ns" {
  zone_id = aws_route53_zone.nobleman_me.zone_id
  name    = "kops.davido.live"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.kops_nobleman_me.name_servers
}

resource "aws_s3_bucket" "kops_state" {
  bucket = "${random_pet.bucket_name.id}-kops-state"
}

resource "random_pet" "bucket_name" {}





