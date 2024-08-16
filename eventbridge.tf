resource "aws_cloudwatch_event_rule" "every_10_minutes" {
  name        = "every_10_minutes_rule"
  description = "trigger datasaver_lambda every 10 minute"

  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_10_minutes.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.datasaver_lambda.arn
}