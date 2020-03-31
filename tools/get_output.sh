#!/bin/bash
RG_NAME="$1"
DEPLOYMENT_NAME="$2"
OUTPUT_KEY="properties.outputs.$3.value"
if [ $# -ne 3 ]; then
    echo "* Usage: $0 <RESOURCE_GROUP> <DEPLOYMENT_NAME> <OUTPUT_NAME>"
    echo "         bash $0 testARMtemplate001 webapps_deploy possibleOutboundIpAddresses"
    echo "* If you want debug printing, set arbitary value to IS_DEBUG environment variable."
    exit 0
fi

if [ ! -z "${IS_DEBUG}" ]; then
    echo "@@@ az group deployment show --resource-group ¥"${RG_NAME}¥" --name ¥"${DEPLOYMENT_NAME}¥" --query ¥"${OUTPUT_KEY}¥" -o tsv"
fi
az group deployment show --resource-group "${RG_NAME}" --name "${DEPLOYMENT_NAME}" --query "${OUTPUT_KEY}" -o tsv
if [ $? -ne 0 ]; then
    echo "Failed to show deployment output value."
    exit $?
fi

exit 0
