#------------------------------------------------
#  must be run with the `source` command.
#    e.g.) $ source awsmfa.sh
#------------------------------------------------


# configuration

DURATION_HOURS=12



# main processing

ret=`aws sts get-caller-identity`
if [ $? -ne 0 ]; then
    echo;
    return 1
fi

user_arn=`echo ${ret} | jq -r ".Arn"`
mfa_arn=${user_arn/:user\//:mfa\/}
echo ${mfa_arn}

echo -n "> Input one-time-password : "
read otp
if [ -z "${otp}" ] ; then
    echo "-- skip : input is empty."
    return 0
fi


duration_seconds=$((${DURATION_HOURS} * 60 * 60))
ret=`aws sts get-session-token \
    --duration-seconds ${duration_seconds} \
    --serial-number "${mfa_arn}" \
    --token-code "${otp}"`

if [ $? -ne 0 ]; then
    echo;
    return 1
fi


access_key_id=`echo ${ret} | jq -r ".Credentials.AccessKeyId"`
secret_access_key=`echo ${ret} | jq -r ".Credentials.SecretAccessKey"`
session_token=`echo ${ret} | jq -r ".Credentials.SessionToken"`

export AWS_ACCESS_KEY_ID=${access_key_id}
export AWS_SECRET_ACCESS_KEY=${secret_access_key}
export AWS_SESSION_TOKEN=${session_token}

echo "-- Maybe successful."

return 0
