#-------storage/main.tf-------

#Create a random ID. S3 buckets have to be unique. No two S3 buckets can share a name
resource "random_id" "tf_bucket_id" {
  byte_length = 2 #this is plenty. also the tf_bucket_id will be appended to the random resource
}

#Create the bucket

resource "aws_s3_bucket" "tf_code" {
  bucket = "${var.project_name}-${random_id.tf_bucket_id.dec}"
  acl = "private"
  force_destroy = true #destroys the bucket and anything inside of it

  tags {
      Name = "tf_bucket"
  }
}

