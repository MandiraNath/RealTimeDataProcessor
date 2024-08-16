
resource "aws_s3_bucket" "terraform_fargate_state" {
  bucket = "terraform-state-bucket"
  versioning {
    enabled = true
  }
}


# this bucket will keep real time data in parquet format
resource "aws_s3_bucket" "data_bucket" {
  bucket  = "realtime-data-save-bucket"
  tags    = {
	Name          = "realtime-data-save-bucket"
	Environment    = "Dev"
  }
}



# this bucket will keep zip files needed for Lambda
resource "aws_s3_bucket" "lambda-bucket" {
  bucket = "terraform-serverless-lambdacode"

  tags = {
    Name        = "terraform-serverless-lambdacode"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_ownership_controls" "lambda_bucket_ownership_controls" {
  bucket = "${aws_s3_bucket.lambda-bucket.id}"

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# upload zip to s3 and then update lambda function from s3
resource "aws_s3_bucket_object" "dataprocessor_file_upload" {
  bucket = "${aws_s3_bucket.lambda-bucket.id}"
  key    = "DataProcessor/dataprocessor_lambda.zip"
  source = "${data.archive_file.dataprocessor_lambda_handler_archive_file.output_path}" 
}

# upload zip to s3 and then update lambda function from s3
resource "aws_s3_bucket_object" "datasaver_file_upload" {
  bucket = "${aws_s3_bucket.lambda-bucket.id}"
  key    = "DataProcessor/datasaver_lambda.zip"
  source = "${data.archive_file.datasaver_lambda_handler_archive_file.output_path}" 
}

# upload zip to s3 and then update lambda function from s3
resource "aws_s3_bucket_object" "datasimulator_file_upload" {
  bucket = "${aws_s3_bucket.lambda-bucket.id}"
  key    = "DataProcessor/datasimulator_lambda.zip"
  source = "${data.archive_file.datasimulator_lambda_handler_archive_file.output_path}" 
}

data "archive_file" "dataprocessor_lambda_handler_archive_file" {
  type        = "zip"
  source_dir  = "DataProcessor"
  output_path = "dataprocessor_lambda.zip"
}

data "archive_file" "datasaver_lambda_handler_archive_file" {
  type        = "zip"
  source_dir  = "DataSaver"
  output_path = "datasaver_lambda.zip"
}

data "archive_file" "datasimulator_lambda_handler_archive_file" {
  type        = "zip"
  source_dir  = "DataSimulator"
  output_path = "datasimulator_lambda.zip"
}