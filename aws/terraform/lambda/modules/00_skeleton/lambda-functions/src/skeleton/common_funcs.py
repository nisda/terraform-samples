import urllib.parse
import urllib.request
import os
import json
import logging
import datetime
import decimal
import uuid


#----------------------------------
#   Logger
#----------------------------------
def init_logger():
    # RootLoggerに設定
    logger = logging.getLogger()
    log_level = os.getenv("LOG_LEVEL", "INFO")
    logger.setLevel(logging.getLevelName(log_level))
    for h in logger.handlers:
        h.setFormatter(logging.Formatter("[%(levelname)s] %(message)s\n"))
    return

# logger初期化
init_logger()


#----------------------------------
#   json.dump-serialize
#----------------------------------

# usage:
#   json.dumps(variable, default=common_funcs.json_serialize)
def json_serialize(obj):
    # datetime
    if isinstance(obj, (datetime.datetime, datetime.date)):
        return obj.isoformat()
    # defimal
    if isinstance(obj, decimal.Decimal):
        if '.' in str(obj):
            return float(obj)
        else:
            return int(obj)
    # bytes
    if isinstance(obj, bytes):
        return obj.decode()
    # uuid
    if isinstance(obj, uuid.UUID):
        return str(obj)
    # 上記以外はサポート対象外.
    raise TypeError ("Type %s not serializable" % type(obj))



#----------------------------------
#   Parameter-store
#----------------------------------
# AWS標準の LambdaLayer `AWS-Parameters-and-Secrets-Lambda-Extension` が必要。
def get_parameter_store(name:str, is_secret:bool=False):
    aws_session_token = os.environ.get('AWS_SESSION_TOKEN')

    param_name_quoted = urllib.parse.quote_plus(name, safe='=&')
    decryption = str(is_secret).lower()

    endpoint = f"http://localhost:2773/systemsmanager/parameters/get?name={param_name_quoted}&withDecryption={decryption}"
    headers = {"X-Aws-Parameters-Secrets-Token": aws_session_token}
    request = urllib.request.Request(endpoint, method='GET', headers=headers)
    with urllib.request.urlopen(request) as response:
        return json.loads(response.read().decode("utf-8")).get('Parameter').get('Value')

