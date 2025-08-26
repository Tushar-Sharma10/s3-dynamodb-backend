# GENERATE RANDOM 2 BYTE HEX SUFFIX TO MAKE THE BUCKET NAME GLOBALLY UNIQUE
resource "random_id" "bucket_name_suffix" {
  byte_length = 2
}

# CREATE S3 BUCKET
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "tushar-tf-backend${random_id.bucket_name_suffix.hex}"
  force_destroy = true
}

# MAKE THE BUCKET PRIVATE
resource "aws_s3_bucket_acl" "private_bucket" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}

# ENABLE VERSIONING
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# BLOCK PUBLIC ACCESS FROM EVERY POSSIBILITY
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ENABLE ENCRYPTION
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# CREATE A DYNAMODB DATABASE
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform_state_lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}