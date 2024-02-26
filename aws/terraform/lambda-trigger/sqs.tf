resource "aws_sqs_queue" "trigger_queue" {
  name                       = "${local.prefix}-trigger-queue"
  visibility_timeout_seconds = 30     # default: 30
  message_retention_seconds  = 345600 # default: 345600(4 days)
  max_message_size           = 262144 # default: 262144(256 KiB)
  delay_seconds              = 0      # default: 0
  receive_wait_time_seconds  = 0      # default: 0
  sqs_managed_sse_enabled    = true

  # DLQ
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.trigger_queue_dlq.arn
    maxReceiveCount     = 2
  })

  #   # FIFO
  #   fifo_queue                  = false
  #   content_based_deduplication = false
  #   deduplication_scope         = "messageGroup"
  #   fifo_throughput_limit       = "perMessageGroupId"

}

resource "aws_sqs_queue" "trigger_queue_dlq" {
  name = "${local.prefix}-trigger-queue-dlq"
}

resource "aws_sqs_queue_redrive_allow_policy" "trigger_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.trigger_queue_dlq.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.trigger_queue.arn]
  })
}
