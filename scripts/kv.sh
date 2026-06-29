#!/bin/bash

FILE="$1"
KEY="$2"
VALUE="$3"

if [ $# -lt 2 ]; then
  echo "Usage: kv.sh <file> <key> [value]"
  exit 1
fi

touch "$FILE"

if [ $# -eq 3 ]; then
  # SET
  if grep -q "^${KEY}=" "$FILE" 2>/dev/null; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "s|^${KEY}=.*|${KEY}=${VALUE}|" "$FILE"
    else
      sed -i "s|^${KEY}=.*|${KEY}=${VALUE}|" "$FILE"
    fi
  else
    echo "${KEY}=${VALUE}" >>"$FILE"
  fi
else
  # GET
  VALUE=$(grep "^${KEY}=" "$FILE" 2>/dev/null | cut -d'=' -f2-)
  if [ -n "$VALUE" ]; then
    echo "$VALUE"
  else
    exit 1
  fi
fi
