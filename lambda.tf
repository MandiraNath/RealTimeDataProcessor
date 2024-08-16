resource "aws_lambda_function" "dataprocessor_lambda" {
  function_name = "DataProcessorLambda"

  # The bucket name as created earlier with "aws s3api create-bucket"
  
  memory_size = 1024
  # "process_lambda" is the filename within the zip file (dataprocessor_lambda.py) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  role             = "${aws_iam_role.lambda_exec.arn}"
  handler          = "dataprocessor_lambda.handler"
  filename = "${data.archive_file.dataprocessor_lambda_handler_archive_file.output_path}"
  source_code_hash = "${data.archive_file.dataprocessor_lambda_handler_archive_file.output_base64sha256}"
  runtime          = "python3.12"
}

resource "aws_lambda_function" "datasaver_lambda" {
  function_name = "DataSaverLambda"

  # The bucket name as created earlier with "aws s3api create-bucket"
  
  

  memory_size = 512
  
  # "receive_lambda" is the filename within the zip file (receive_lambda.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  role             = "${aws_iam_role.lambda_exec.arn}"
  handler          = "datasaver_lambda.handler"
  filename = "${data.archive_file.datasaver_lambda_handler_archive_file.output_path}"
  source_code_hash = "${data.archive_file.datasaver_lambda_handler_archive_file.output_base64sha256}"
  runtime          = "python3.12"
}

resource "aws_lambda_function" "datasimulator_lambda" {
  function_name = "DataSimulatorLambda"

  # The bucket name as created earlier with "aws s3api create-bucket"
  
  
  memory_size = 512

  # "flight_data_lambda" is the filename within the zip file (datasimulator_lambda.py) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  role             = "${aws_iam_role.lambda_exec.arn}"
  handler          = "datasimulator_lambda.handler"
  filename = "${data.archive_file.datasimulator_lambda_handler_archive_file.output_path}"
  source_code_hash = "${data.archive_file.datasimulator_lambda_handler_archive_file.output_base64sha256}"
  runtime          = "python3.12"
}

data "aws_lambda_function" "dataprocessor_lambda" {
  function_name = "DataProcessorLambda"
}

data "aws_lambda_function" "datasaver_lambda" {
  function_name = "DataSaverLambda"
}

data "aws_lambda_function" "datasimulator_lambda" {
  function_name = "DataSimulatorLambda"
}


resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket_ownership_controls]

  bucket = "${aws_s3_bucket.lambda-bucket.id}"
  acl = "private"
}

