# pull base image
FROM alpine:3.16

ARG ANSIBLE_CORE_VERSION_ARG "2.12.1"
ARG ANSIBLE_VERSION
ARG ANSIBLE_LINT
ARG ANSIBLE_ROLLE_DIR
ARG ANSIBLE_PLAYBOOK_DIR
ARG ANSIBLE_VAULT_PASS_FILE
ENV ANSIBLE_CORE_VERSION ${ANSIBLE_CORE_VERSION_ARG}
ENV ANSIBLE_VERSION ${ANSIBLE_VERSION}
ENV ANSIBLE_CMDB ${ANSIBLE_CMDB}
ENV ANSIBLE_LINT ${ANSIBLE_LINT}

# Labels.
LABEL maintainer="tobkern1980@gmail.com" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="willhallonline/ansible" \
    org.label-schema.description="Ansible inside Docker" \
    org.label-schema.url="https://github.com/kernt/ansible-docker" \
    org.label-schema.vcs-url="https://github.com/kernt/ansible-docker" \
    org.label-schema.vendor="Only if an real failor" \
    org.label-schema.docker.cmd="docker run --rm -it -v $(pwd):/ansible ~/.ssh/id_rsa:/root/id_rsa kernt/ansible-docker:2.11-alpine-3.14"

RUN apk --no-cache add \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        musl-dev \
        gcc \
        cargo \
        openssl-dev \
        libressl-dev \
        build-base && \
    pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography cffi && \
    pip3 install ansible-core==${ANSIBLE_CORE_VERSION} && \
    pip3 install ansible==${ANSIBLE_VERSION} ansible-lint==${ANSIBLE_LINT} && \
    pip3 install ansible==${ANSIBLE_VERSION} ANSIBLE_CMDB==${ANSIBLE_CMDB} && \
    pip3 install mitogen jmespath && \
    pip3 install --upgrade pywinrm && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.cargo
# stuff for ANSIBLE_CMDB bur wth phyton3
RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
