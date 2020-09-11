# //////////////////////////////
# VARIABLES
# //////////////////////////////
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "bucket_name" {
  default = "red30-tfstate"
}

# //////////////////////////////
# PROVIDER
# //////////////////////////////
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = "us-east-2"
}

# //////////////////////////////
# TERRAFORM USER
# //////////////////////////////
data "aws_iam_user" "terraform" {
  user_name = "terraform"
}

# //////////////////////////////
# S3 BUCKET
# //////////////////////////////
resource "aws_s3_bucket" "red30-tfremotestate" {
  bucket = var.bucket_name
  force_destroy = true
  acl = "private"

  versioning {
    enabled = true
  }

  # Grant read/write access to the terraform user
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${data.aws_iam_user.terraform.arn}"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "red30-tfremotestate" {
  bucket = aws_s3_bucket.red30-tfremotestate.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# //////////////////////////////
# DYNAMODB TABLE
# //////////////////////////////
resource "aws_dynamodb_table" "tf_db_statelock" {
  name           = "red30-tfstatelock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# //////////////////////////////
# IAM POLICY
# //////////////////////////////
resource "aws_iam_user_policy" "terraform_user_dbtable" {
  name = "terraform"
  user = data.aws_iam_user.terraform.user_name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["dynamodb:*"],
            "Resource": [
                "${aws_dynamodb_table.tf_db_statelock.arn}"
            ]
        }
   ]
}

EOF
}

