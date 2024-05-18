resource "aws_s3_bucket" "two-tier-architecture-with-terraform" {
  bucket = "two-tier-architecture-with-terraform"
  tags = {
    Name        = "two-tier-architecture-with-terraform"
  }
}