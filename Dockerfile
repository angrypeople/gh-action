FROM alpine:3.14

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apk --no-cache add \
    curl \
    bash \
    tar

RUN addgroup -g ${GROUP_ID} github \
    && adduser -D -s /bin/bash -u ${USER_ID} -G github github

USER github

WORKDIR /runner

COPY get_runner_version.sh /runner

RUN set -eux; \
    /bin/bash chmod +x get_runner_version.sh ; \
    /bin/bash get_runner_version.sh > runner_version.txt; \
    curl -sSL https://github.com/actions/runner/releases/download/v$(cat runner_version.txt)/actions-runner-linux-x64-$(cat runner_version.txt).tar.gz | tar -xz; \
    rm runner_version.txt

ENTRYPOINT ["/runner/actions-runner"]
CMD ["--help"]
