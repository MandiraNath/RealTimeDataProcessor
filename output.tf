
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


output "kinesis_stream"{
  value       = aws_kinesis_stream.kinesis_stream.arn
  description = "ARN for the created kinesis stream"
}


output "shard_count" {
  description = "Number of shards provisioned."
  value       = try(aws_kinesis_stream.kinesis_stream.shard_count, null)
}

output "stream_arn" {
  description = "ARN of the Kinesis stream."
  value       = join("", aws_kinesis_stream.kinesis_stream.*.arn)
}
