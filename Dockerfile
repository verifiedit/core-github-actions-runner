FROM quay.io/evryfs/github-actions-runner:latest

ENV COMPOSER_ALLOW_SUPERUSER=1

USER root

RUN DEBIAN_FRONTEND=noninteractive apt-get install software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php8.0 git zip unzip \
    && pip install ansible boto3 boto netaddr kubernetes \
    && curl -sS --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x aws-iam-authenticator && mv aws-iam-authenticator /usr/local/bin

COPY scripts/install-runner /usr/local/bin/install-runner

RUN chmod +x /usr/local/bin/install-runner

WORKDIR /home/runner

USER runner

RUN mkdir ~/.kube

ENTRYPOINT ["/entrypoint.sh"]