#!/bin/bash
set -e

if [ -z "${RUNNER_TOKEN}" ]; then
  echo "RUNNER_TOKEN 환경 변수가 설정되지 않았습니다."
  exit 1
fi

if [ -z "${RUNNER_REPOSITORY_URL}" ]; then
  echo "RUNNER_REPOSITORY_URL 환경 변수가 설정되지 않았습니다."
  exit 1
fi

if [ -z "${RUNNER_NAME}" ]; then
  RUNNER_NAME=$(hostname)
fi

./config.sh --url ${RUNNER_REPOSITORY_URL} --token ${RUNNER_TOKEN} --name ${RUNNER_NAME} --work _work --unattended --replace

exec ./run.sh
