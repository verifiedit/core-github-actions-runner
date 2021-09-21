FROM quay.io/evryfs/github-actions-runner:latest

ENV COMPOSER_ALLOW_SUPERUSER=1

USER root

RUN DEBIAN_FRONTEND=noninteractive apt-get install software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php8.0 git zip unzip \
    && pip install ansible \
    && curl -sS --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /home/runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]