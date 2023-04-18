FROM alpine:3.14

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apk --no-cache add \
    curl \
    bash \
    tar \
    sudo

RUN addgroup -g ${GROUP_ID} github \
    && adduser -D -s /bin/bash -u ${USER_ID} -G github github \
    && echo "github ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /runner

COPY get_runner_version.sh /runner
RUN chmod +x /runner/get_runner_version.sh

RUN set -eux; \
    ./get_runner_version.sh > runner_version.txt; \
    runner_version=$(cat runner_version.txt); \
    curl -sSL "https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz" | tar -xz; \
    rm runner_version.txt

# GitHub Action Runner를 실행할 사용자 변경
USER github

# 필요한 종속성 설치
RUN sudo ./bin/installdependencies.sh

# GitHub Action Runner를 실행하기 위한 스크립트 작성
COPY entrypoint.sh /runner
RUN sudo chmod +x /runner/entrypoint.sh

# 엔트리 포인트 설정
ENTRYPOINT ["/runner/entrypoint.sh"]
