FROM python:3.11-slim

# Fix Ansible locale error
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Terraform version
ARG TF_VERSION=1.13.4
# User configuration
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# 1. Install System Deps & Create User
# - sudo, git, openssh-client: Required for DevPod/VS Code agent & git operations
# - curl, unzip: Required to download/install Terraform
# - iputils-ping, dnsutils: Helpful for network debugging in your lab
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       sudo \
       git \
       openssh-client \
       curl \
       unzip \
       iputils-ping \
       dnsutils \
       iproute2 \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Ansible
RUN pip install --upgrade pip && \
    pip install --no-cache-dir ansible ansible-lint argcomplete

# 3. Install Terraform (Manual Yandex Mirror)
RUN curl -Lo terraform.zip "https://hashicorp-releases.yandexcloud.net/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && chmod +x /usr/local/bin/terraform \
    && rm terraform.zip

# 4. Setup Workspace Directory
RUN mkdir -p /workspace/devops-home-lab \
    && chown -R $USERNAME:$USERNAME /workspace

# 5. Switch to User
USER $USERNAME

# 6. Configure Shell
# Setup ansible autocomplition
RUN echo 'eval $(register-python-argcomplete ansible)' >> ~/.bashrc \
    && echo 'eval $(register-python-argcomplete ansible-playbook)' >> ~/.bashrc \
    && echo 'eval $(register-python-argcomplete ansible-galaxy)' >> ~/.bashrc

WORKDIR /workspace
