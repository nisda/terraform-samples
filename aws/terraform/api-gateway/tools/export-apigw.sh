#----------------------------------------------
#   API-Gteway の API定義をエクスポート
#----------------------------------------------
SCRIPT_DIR=$(cd $(dirname $0); pwd)
API_ID="xxxxxxxxxx"
STAGE_NAME="xxx"
type="oas30"    # oas30 or swagger2

aws apigateway get-export \
    --region ap-northeast-1 \
    --parameters extensions='apigateway' \
    --rest-api-id ${API_ID} \
    --stage-name ${STAGE_NAME} \
    --export-type ${type} \
    ${SCRIPT_DIR}/export-apigw_apigw-def-${type}.json


