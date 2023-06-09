FROM ubuntu:20.04

ARG USER_ID=1000
ARG GROUP_ID=1000
ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치
RUN apt-get update && \
    apt-get install -y curl sudo git tzdata


RUN groupadd -g ${GROUP_ID} github && \
    useradd -m -s /bin/bash -u ${USER_ID} -g github github && \
    echo "github ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /runner

COPY get_runner_version.sh /runner
RUN chmod +x /runner/get_runner_version.sh

RUN set -eux; \
    ./get_runner_version.sh > runner_version.txt; \
    runner_version=$(cat runner_version.txt); \
    curl -sSL "https://github.com/actions/runner/releases/download/v${runner_version}/actions-runner-linux-x64-${runner_version}.tar.gz" | tar -xz; \
    rm runner_version.txt

RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce

ENV DOCKER_BUILDX_VERSION v0.10.4
RUN curl -fsSL "https://github.com/docker/buildx/releases/download/${DOCKER_BUILDX_VERSION}/buildx-${DOCKER_BUILDX_VERSION}.linux-amd64" -o /usr/libexec/docker/cli-plugins/docker-buildx \
    && chmod a+x /usr/libexec/docker/cli-plugins/docker-buildx

RUN sudo usermod -aG docker github
USER github

RUN sudo ./bin/installdependencies.sh

# 권한조정
RUN sudo chown -R github:github /runner

COPY entrypoint.sh /runner
RUN sudo chmod +x /runner/entrypoint.sh


ENTRYPOINT ["/runner/entrypoint.sh"]