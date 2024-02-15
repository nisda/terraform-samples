import os
import logging
import json
import common_funcs

PS_NAME_PLAIN  = os.getenv("SSM_PLAIN_STRING_PS")
PS_NAME_SECRET = os.getenv("SSM_SECRET_STRING_PS")


def lambda_handler(event, context):
    logger_0 = logging.getLogger()    # RootLogger
    logger_0.info("-- event:")
    logger_0.info(event)
    logger_0.info(json.dumps(event, default=common_funcs.json_serialize))

    # Logger
    logger_0.info("-- logger")
    logger_1 = logging.getLogger(__name__)
    logger_2 = logging.getLogger("test")
    logger_2.setLevel(logging.DEBUG)
    logget_output_test(logger_1)
    logget_output_test(logger_2)

    # ParameterStore
    logger_0.info("-- ParameterStore")
    logger_0.info("plain  : {}".format(common_funcs.get_parameter_store(name=PS_NAME_PLAIN)))
    logger_0.info("secret : {}".format(common_funcs.get_parameter_store(name=PS_NAME_SECRET, is_secret=True)))

    return {
        'statusCode': 200,
        'body': {}
    }

def logget_output_test(logger:logging.Logger):
    logger.critical(f"{logger.name} ------------------")
    logger.critical("critical")
    logger.error("error")
    logger.warning("warning")
    logger.info("info")
    logger.debug("debug")
    return

