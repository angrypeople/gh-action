#!/bin/bash

JSON_DATA=$(curl -s https://api.github.com/repos/actions/runner/releases/latest)

if [ -z "${JSON_DATA}" ]; then
  echo "Failed to retrieve latest release data"
  exit 1
fi

LATEST_VERSION=$(echo "${JSON_DATA}" | jq -r '.tag_name' | cut -c 2-)

if [ -z "${LATEST_VERSION}" ]; then
  echo "Failed to extract latest version"
  exit 1
fi


echo "LATEST_VERSION: ${LATEST_VERSION}"
