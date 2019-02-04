#!/bin/bash
INPUT_FILE=${1:-metrics.txt}

if [ ! -f "$INPUT_FILE" ]
then
  echo "File not found: $INPUT_FILE"
  exit 1
fi

LINES_IN_FILE=`wc -l "$INPUT_FILE" | cut -d " " -f 1`
DAYS_TO_SUBSTRACT=$((1 + LINES_IN_FILE / 12))
START_DATE=`date -d "$(date) - $DAYS_TO_SUBSTRACT days"`

cat "$INPUT_FILE" | while read LINE
do
  MINUTES_TO_ADD=$((MINUTES_TO_ADD + RANDOM % 60 + 1))

  METRIC="$LINE $(date -d "$START_DATE + $MINUTES_TO_ADD minutes" +%s)000000000"
  curl -s -i -XPOST 'http://localhost:8086/write?db=envs' -d "$METRIC" > /dev/null
  if [[ $? -eq 0 ]]
  then
    echo "$METRIC"
  fi
done

