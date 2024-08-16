terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}


resource "aws_kinesis_stream" "kinesis_stream" {
  name             = "frequency-data-stream"
  shard_count      = 1
  retention_period = 24
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
