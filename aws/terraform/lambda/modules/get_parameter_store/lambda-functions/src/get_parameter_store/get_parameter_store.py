import os
import json
import urllib.parse
import urllib.request

SSM_PLAIN_STRING_PS = os.environ.get('SSM_PLAIN_STRING_PS')
SSM_SECRET_STRING_PS = os.environ.get('SSM_SECRET_STRING_PS')


def __get_parameter_store(param_name:str, is_secret:bool=False):
    aws_session_token = os.environ.get('AWS_SESSION_TOKEN')

    param_name_quoted = urllib.parse.quote_plus(param_name, safe='=&')
    decryption = str(is_secret).lower()

    endpoint = f"http://localhost:2773/systemsmanager/parameters/get?name={param_name_quoted}&withDecryption={decryption}"
    headers = {"X-Aws-Parameters-Secrets-Token": aws_session_token}
    request = urllib.request.Request(endpoint, method='GET', headers=headers)
    with urllib.request.urlopen(request) as response:
        return json.loads(response.read().decode("utf-8")).get('Parameter').get('Value')



def lambda_handler(event, context):

    plain  = __get_parameter_store(SSM_PLAIN_STRING_PS, False)
    print(plain)

    secret = __get_parameter_store(SSM_SECRET_STRING_PS, True)
    print(secret)

    return {
        'statusCode': 200,
        'body': {
            'plain': plain,
            'secret': secret,
        }
    }
