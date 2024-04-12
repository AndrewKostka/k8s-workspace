FROM ubuntu:22.04

RUN apt-get update \
  && apt-get install -y \
    unzip \
    wget \
    git \ 
    make \
    ca-certificates \
    gnupg \
    curl \
    vim

RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update \
  && apt-get install -y \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin

WORKDIR /usr/src/tools/minikube
RUN wget https://github.com/kubernetes/minikube/releases/download/v1.32.0/minikube-linux-amd64
RUN install minikube-linux-amd64 /usr/local/bin/minikube

WORKDIR /usr/src/tools/helm
RUN wget https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz
RUN tar -zxvf helm-v3.14.2-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin/helm

WORKDIR /usr/src/tools/helmfile
RUN wget https://github.com/helmfile/helmfile/releases/download/v0.162.0/helmfile_0.162.0_linux_amd64.tar.gz
RUN tar -zxvf helmfile_0.162.0_linux_amd64.tar.gz
RUN mv helmfile /usr/local/bin/helmfile

WORKDIR /usr/src/tools/kubectl
RUN wget https://dl.k8s.io/release/v1.29.2/bin/linux/amd64/kubectl
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

WORKDIR /usr/src/tools/gcloud
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-471.0.0-linux-x86_64.tar.gz
RUN tar -zxvf google-cloud-cli-471.0.0-linux-x86_64.tar.gz
RUN google-cloud-sdk/install.sh --usage-reporting false
ENV PATH $PATH:/usr/src/tools/gcloud/google-cloud-sdk/bin

WORKDIR /usr/src/tools/digitalocean
RUN wget https://github.com/digitalocean/doctl/releases/download/v1.104.0/doctl-1.104.0-linux-amd64.tar.gz
RUN tar -zxvf doctl-1.104.0-linux-amd64.tar.gz
RUN mv doctl /usr/local/bin/doctl

WORKDIR /usr/src/tools/opentofu
RUN wget https://github.com/opentofu/opentofu/releases/download/v1.6.2/tofu_1.6.2_linux_amd64.zip
RUN unzip tofu_1.6.2_linux_amd64.zip
RUN mv tofu /usr/local/bin/tofu

ARG USER_GID
RUN groupadd -g ${USER_GID} user

ARG USER_UID
RUN useradd -u ${USER_UID} -g ${USER_GID} -ms /bin/bash user

ARG DOCKER_GID
RUN groupadd -g ${DOCKER_GID} docker
RUN usermod -aG docker user

USER user
WORKDIR /home/user

RUN helm plugin install --version v3.9.5 https://github.com/databus23/helm-diff
RUN helm plugin install --version v0.16.0 https://github.com/aslafy-z/helm-git

ARG MINIKUBE_MEMORY
RUN minikube config set memory $MINIKUBE_MEMORY

ARG MINIKUBE_CPUS
RUN minikube config set cpus $MINIKUBE_CPUS
