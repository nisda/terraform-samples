
export AWS_DEFAULT_REGION="ap-northeast-1"
QUEUE_URL=`aws sqs get-queue-url --queue-name "lambda-trigger-poc-trigger-queue" | jq -r ".QueueUrl"`
echo ${QUEUE_URL}
echo "--------------------"

aws sqs send-message --queue-url ${QUEUE_URL} --message-body "aaa"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "bbb"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "ccc"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "ddd"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "eee"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "XXX error"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "fff"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "ggg"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "hhh"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "YYY error"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "iii"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "jjj"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "kkk"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "lll"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "mmm"
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "nnn"

