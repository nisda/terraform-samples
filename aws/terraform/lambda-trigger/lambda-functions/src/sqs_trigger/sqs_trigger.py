# coding: utf-8
import json
from concurrent.futures import ThreadPoolExecutor



def sqs_record_processing(record:dict):
    id_short = record['messageId'].split("-")[0]

    message_body = record['body']
    print(f"[{id_short}] body = {message_body}")

    import random
    value = random.randint(0, 3)
    print(f"[{id_short}] value = {value}")

    import time
    time.sleep(2)

    # リトライテスト用： ランダム値が 0 のときはエラー
    calc_result = 10 / value
    print(f"[{id_short}] 10 / {value} = {calc_result}")

    # DLQテスト用：特定文言のときはエラーにする
    if message_body.endswith("error"):
        raise Exception(f"data error! `{message_body}`")

    return calc_result



def lambda_handler(event, context):
    print("event: " + json.dumps(event))
 
    # マルチスレッド処理
    process_results = {}
    batch_item_failure_ids = []
    with ThreadPoolExecutor() as executor:
        processes:dict = {}
        # 処理実行
        for idx in range(0, len(event["Records"])):
            record:dict = event["Records"][idx]
            id:str      = record['messageId']
            processes[id] = executor.submit(
                sqs_record_processing,
                record=record,
            )
        # 結果取得
        for id, process in processes.items():
            try:
                process_results[id] = process.result()
            except Exception as e:
                process_results[id] = str(e)
                batch_item_failure_ids.append(id)

    # 結果表示
    print("process-results: " + json.dumps(process_results))

    # 処理NGのキューを差し戻すための仕組み。
    # https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/with-sqs.html#services-sqs-batchfailurereporting
    sqs_result = {
        "batchItemFailures" : [ {"itemIdentifier": x} for x in batch_item_failure_ids ]
    }
    print("lambda-result: " + json.dumps(sqs_result))
    return sqs_result


