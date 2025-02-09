import logging
import os

from aws_lambda_powertools import Logger
logger = Logger(child=True)


def lambda_main(event, context):
    logger.critical("*** critical")
    logger.error("*** error")
    logger.warning("*** warnning")
    logger.info("*** info")
    logger.debug("*** debug")

    return "main ret!"

