import json
from refer import twice, ReferClass

def lambda_handler(event, context):

    print()
    print("-- class inheritance")
    refer = ReferClass()
    print(refer.squared(1))
    print(refer.squared(2))
    print(refer.squared(3))
    print(refer.squared(4))

    print()
    print("-- refer class")
    print(twice(1))
    print(twice(2))
    print(twice(3))
    print(twice(4))



    return {
        'statusCode': 200,
        'body': event
    }
