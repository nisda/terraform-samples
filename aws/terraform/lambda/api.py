# coding: utf-8

import urllib.request
import urllib.parse
import json
from typing import List, Tuple

class RestAPI:

    def __init__(self, base_url:str, base_headers:dict=None, base_query_strings:dict=None):
        '''コンストラクタ'''
        self._base_url = base_url.rstrip("/")
        self._base_headers = base_headers or {}
        self._base_query_strings = base_query_strings or {}
        return

    def request(self, method:str, path:str, headers:dict=None, query_strings:dict=None, data:dict=None):
        '''リクエスト'''

        # QueryString処理
        merged_qs:dict = {**self._base_query_strings, **(query_strings or {})}
        qs_tuples:List[Tuple] = []
        for k,v in merged_qs.items():
            if isinstance(v, list):
                qs_tuples.extend([(k,x) for x in v])
            else:
                qs_tuples.append((k,v))
        qs:str = urllib.parse.urlencode(qs_tuples)

        # URL処理
        url:str = f"{self._base_url}/{path.lstrip('/')}"
        url_full:str = f"{url}?{qs}"

        # Header処理
        headers_merged = {**self._base_headers, **(headers or {})}

        # リクエスト生成
        if data is None:
            req = urllib.request.Request(
                method=method.upper(),
                url=url_full,
                headers=headers_merged,
            )
        else:
            encoded_data = urllib.parse.urlencode(data).encode('utf-8')
            req = urllib.request.Request(
                method=method.upper(),
                url=url_full,
                headers=headers_merged,
                data=encoded_data,
            )

        # リクエスト実行
        with urllib.request.urlopen(req) as res:
            return {
                "headers": res.getheaders(),
                "status": res.status,
                "reason": res.reason,
                "msg": res.msg,
                "body": res.read().decode(),
            }



# テストルーチン
if __name__ == '__main__':

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

