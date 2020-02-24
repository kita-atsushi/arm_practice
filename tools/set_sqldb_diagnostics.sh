#!/bin/bash
CWD="$(cd $(dirname $0) && pwd)"
TARGET_SQL_DBS_RESOURCE_ID=$1
if [ $# -ne 1 ]; then
  echo "Usage: $0 <TARGET_SQL_DBS_RESOURCE_ID>"
  exit 0
fi
LOG_ANALYTICS_WS_RG_NAME="testARMtemplate001"
LOG_ANALYTICS_WS="testLogAnalytics2020022401"
DIAGNOSTIC_NAME="ibsharediagnostic"
ROLE="sqldb"

function replace_config_item() {
  local TEMPLATE_FILEPATH=$1
  local ITEM_NAME=$2
  local ITEM_VALUE=$3
  sed -i "${TEMPLATE_FILEPATH}" -e "s/@@IS_${ITEM_NAME}@@/${ITEM_VALUE}/g"
}

cd ${CWD}/target/${ROLE}
cp template_logs.txt settings_logs.txt
LOG_ITEMS=(
  "SQLInsights"
  "AutomaticTuning"
  "QueryStoreRuntimeStatistics"
  "QueryStoreWaitStatistics"
  "Errors"
  "DatabaseWaitStatistics"
  "Blocks"
  "Timeouts"
  "Deadlocks"
)
for ele in ${LOG_ITEMS[@]}; do
    replace_config_item "settings_logs.txt" "${ele}" "true"
done

cp template_metrics.txt settings_metrics.txt
METRICS_ITEMS=(
  "Basic"
  "InstanceAndAppAdvanced"
  "WorkloadManagement"
)
for ele in ${METRICS_ITEMS[@]}; do
    replace_config_item "settings_metrics.txt" "${ele}" "true"
done

az monitor diagnostic-settings create \
  --name "${DIAGNOSTIC_NAME}" \
  --resource "${TARGET_SQL_DBS_RESOURCE_ID}" \
  --workspace "${LOG_ANALYTICS_WS}" \
  --resource-group "${LOG_ANALYTICS_WS_RG_NAME}" \
  --logs @settings_logs.txt \
  --metrics @settings_metrics.txt

rm -f settings_logs.txt settings_metrics.txt

exit 0
