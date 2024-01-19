import json
from RestAPI import RestAPI

def lambda_handler(event, context):

    print("***********************************")

    api = RestAPI(
        base_url="https://httpbin.org/",
        base_headers={"bh-api-key": "XXXX"},
        base_query_strings={"bq-api-key": "YYYY"}
    )
    response = api.request(
        method="post",
        path="/post",
        headers={"h-aaa": "AAA", "h-bbb": "BBB"},
        query_strings={"q-aaa": "AAA", "q-bbb": ["BBB", "bbb"]},
        data={"d-aaa": "AAA", "d-bbb": ["BBB", "bbb"]},
    )
    print("ret ----------------")
    print(json.dumps(response, indent=2))
    print("body(json) ----------------")
    print(json.dumps(json.loads(response.get("body")), indent=2))


    print("***********************************")

    api = RestAPI(
        base_url="https://httpbin.org/"
    )
    response = api.request(
        method="patch",
        path="/patch",
        headers={"h-aaa": "AAA", "h-bbb": "BBB"},
        query_strings={"q-aaa": "AAA", "q-bbb": ["BBB", "bbb"]},
        data={"d-aaa": "AAA", "d-bbb": ["BBB", "bbb"]},
    )
    print("ret ----------------")
    print(json.dumps(response, indent=2))
    print("body(json) ----------------")
    print(json.dumps(json.loads(response.get("body")), indent=2))



    return {
        'statusCode': 200,
        'body': event
    }
