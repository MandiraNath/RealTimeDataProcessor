
output "datasaver_lambda_bucket_object" {
  description = "S3 bucket object for the datasaver lambda handler."
  value = aws_s3_bucket_object.datasaver_file_upload
}

output "datasimulator_lambda_bucket_object" {
  description = "S3 bucket object for the datasimulator lambda handler."
  value = aws_s3_bucket_object.datasimulator_file_upload
}

output "dataprocessor_lambda_bucket_object" {
  description = "S3 bucket object for the dataprocessor lambda handler."
  value = aws_s3_bucket_object.dataprocessor_file_upload
}


