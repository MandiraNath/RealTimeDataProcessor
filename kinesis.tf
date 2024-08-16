
resource "aws_kinesis_stream" "kinesis_stream" {
  name             = "frequency-data-stream"
  # shard_count      = 1  #shard_count must not be set when stream_mode is ON_DEMAND
  retention_period = 24

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Product = "Real time data transfer Demo"
  }
}
