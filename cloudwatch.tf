
resource "aws_cloudwatch_log_group" "datasaver_lambda" {
  name = "/aws/lambda/DataSaverLambda"
  retention_in_days = 30

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "datasimulator_lambda_lambda" {
  name = "/aws/lambda/DataSimulatorLambda"
  retention_in_days = 30

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "dataprocessor_lambda" {
  name = "/aws/lambda/DataProcessorLambda"
  retention_in_days = 30

  lifecycle {
    prevent_destroy = false
  }
}