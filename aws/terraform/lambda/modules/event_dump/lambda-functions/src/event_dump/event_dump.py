import json

def lambda_handler(event, context):
    print("event:")
    print(event)
    print("event-json:")
    print(json.dumps(event))

    return {
        'statusCode': 200,
        'body': event
    }
