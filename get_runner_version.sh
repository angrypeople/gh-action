#!/bin/bash

LATEST_URL=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | grep -o -E "https://github.com/actions/runner/releases/download/v[0-9.]+/actions-runner-linux-x64-[0-9.]+.tar.gz")

if [ -z "${LATEST_URL}" ]; then
  echo "Failed to retrieve latest version URL"
  exit 1
fi

LATEST_VERSION=$(echo "${LATEST_URL}" | grep -o -E "v[0-9.]+" | cut -c 2-)

if [ -z "${LATEST_VERSION}" ]; then
  echo "Failed to extract latest version"
  exit 1
fi

echo "${LATEST_VERSION}"