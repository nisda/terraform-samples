import logging
import os
import sys


sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
import src.lambda_main as lambda_main
from src.myutils import simple_di

################################
## これじゃダメ
## コマンドラインパラメータでLogLevelを指定する
##   pytest --log-cli-level=DEBUG　※ロジック内のLogLevel設定も貫通する。
## もしくはpyproject.tomlに書くか？ → pytest.ini でOK
###############################

def test_aaaa():
    event:dict = {"test": "test"}
    context = None
    logger_1 = logging.getLogger(__name__)
    logger_1.debug("de")
    ret = lambda_main.lambda_main(event, context)

    assert True
