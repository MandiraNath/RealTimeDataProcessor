
resource "aws_kinesis_stream" "kinesis_stream" {
  name             = "frequency-data-stream"
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Product = "Real time data transfer Demo"
  }
}
