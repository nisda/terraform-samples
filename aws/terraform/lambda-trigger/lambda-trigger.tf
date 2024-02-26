resource "aws_lambda_event_source_mapping" "sqs_trigger_mapping" {
  event_source_arn = aws_sqs_queue.trigger_queue.arn
  function_name    = aws_lambda_function.sqs_trigger_lambda.arn

  # SQS バッチ処理設定
  batch_size                         = 5  # 最大処理件数
  maximum_batching_window_in_seconds = 30 # 件数が溜まるまで待つ時間。
  scaling_config {
    maximum_concurrency = 2 # lambda同時実行数（最大）
  }
  function_response_types = ["ReportBatchItemFailures"]
}
