#!/bin/sh

# Entry point for myip docker 

# run the update commands every FREQ seconds
while [ 1 ]
do
    curl -X $UPDATE_METHOD -H "User-Agent: ${USER_AGENT}" -d "${ENC_DATA}" $SITE_URL
    # sleep set in env variable FREQ
    sleep $FREQ
done

