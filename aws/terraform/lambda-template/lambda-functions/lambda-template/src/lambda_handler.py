import logging
import os

from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools.utilities import parameters

import lambda_main
from myutils import simple_di
from myutils import json

# ロガー設定（新）
logger = Logger()

# ロガー設定
# LOG_LEVEL:int = logging.getLevelName(os.getenv("LOG_LEVEL", "INFO"))
# logger_1 = logging.getLogger(__name__)
# logger_1.setLevel(LOG_LEVEL)

PS_PLAIN_TEXT = os.getenv("PS_PLAIN_TEXT", "")
PS_SECRET_TEXT = os.getenv("PS_SECRET_TEXT", "")


@logger.inject_lambda_context(log_event=True)
def lambda_handler(event, context:LambdaContext):
    # ログに任意の値を追加可能
    logger.structure_logs(append=True, additional_id="ADD-ID")
    
    logger.debug('debug')
    logger.info('info')
    logger.warning('warning')

    # get ssm-parameter-store
    ps_plain:str = parameters.get_parameter(PS_PLAIN_TEXT)
    ps_secret:str = parameters.get_parameter(PS_SECRET_TEXT, decrypt=True)
    # logger.info(f'ps_plain  = {ps_plain}')
    # logger.info(f'ps_secret = {ps_secret}')
    logger.info(json.dumps({
        "ps_plain" : ps_plain,
        "ps_secret" : ps_secret,
    }))


    # logger_1 = logging.getLogger(__name__)
    # logger_1.info(event)

    # # DI-Container
    # di = simple_di.Container()

    # # call main
    # ret = lambda_main.lambda_main(
    #     event=event,
    #     context=context
    # )

    # logger_1.info(ret)
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Success.'})
    } 



