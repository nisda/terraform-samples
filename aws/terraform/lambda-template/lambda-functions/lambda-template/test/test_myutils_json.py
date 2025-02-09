import os
import sys
import datetime
import decimal
import uuid


sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
from src.myutils import json

def test_json():
    # json文字列に変換
    ret = json.dumps({
        "str": "AAA",
        "datetime_to_str": datetime.datetime.now(),
        "decimal_to_int" : decimal.Decimal("123"),
        "decimal_to_float" : decimal.Decimal("123.000"),
        "uuid_to_str" : uuid.uuid4(),
    })

    # dict に戻してデータ型を判定
    ret = json.loads(ret)
    assert isinstance(ret.get("datetime_to_str"), str)
    assert isinstance(ret.get("decimal_to_int"), int)
    assert isinstance(ret.get("decimal_to_float"), float)
    assert isinstance(ret.get("uuid_to_str"), str)




