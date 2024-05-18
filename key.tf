#Generating the Key pair
resource "tls_private_key" "two-tier-key-pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Storing the Public key in AWS
resource "aws_key_pair" "two-tier-public-key" {
  key_name   = "two-tier-public-key"
  public_key = tls_private_key.two-tier-key-pair.public_key_openssh #Passing the Public Key 
}

resource "aws_s3_object" "private_key_in_bucket" {
  bucket = "two-tier-architecture-with-terraform"
  depends_on = [ aws_s3_bucket.two-tier-architecture-with-terraform ]
  key    = "/two-tier-architecture-with-terraform/two-tier-key-pair.pem"
  content = tls_private_key.two-tier-key-pair.private_key_pem
}
