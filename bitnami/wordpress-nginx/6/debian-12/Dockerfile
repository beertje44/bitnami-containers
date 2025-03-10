# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-02-20T17:58:50Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/wordpress-nginx/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="6.7.2-debian-12-r2" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/wordpress-nginx" \
      org.opencontainers.image.title="wordpress-nginx" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="6.7.2"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gettext less libaudit1 libbrotli1 libbsd0 libbz2-1.0 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libexpat1 libffi8 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libgeoip1 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhashkit2 libhogweed6 libicu72 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.5-0 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmd0 libmemcached11 libncurses6 libnettle8 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre2-8-0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl3 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libwebp7 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 libzstd1 locales openssl procps zlib1g
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8
ENV LANG="en_US.UTF-8"

RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "render-template-1.0.7-13-linux-${OS_ARCH}-debian-12" \
      "php-8.2.27-8-linux-${OS_ARCH}-debian-12" \
      "nginx-1.27.4-3-linux-${OS_ARCH}-debian-12" \
      "mysql-client-11.4.5-1-linux-${OS_ARCH}-debian-12" \
      "wordpress-nginx-6.7.2-1-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update \
  && apt-get install -y autoconf wget build-essential composer git binutils \
  && cd /tmp \
  && wget https://pecl.php.net/get/redis-6.0.2.tgz \
  && tar xzf redis-6.0.2.tgz \
  && cd redis-6.0.2 \
  && /opt/bitnami/php/bin/phpize && ./configure  --with-php-config=/opt/bitnami/php/bin/php-config \
  && make -j32 \
  && make install \
  && echo 'extension=redis.so' >> /opt/bitnami/php/etc/php.ini \
  && cd .. \
  && rm -rf ./redis-6.0.2* \
  && wget https://pecl.php.net/get/opentelemetry-1.1.2.tgz \
  && tar xzf opentelemetry-1.1.2.tgz \
  && cd opentelemetry-1.1.2 \
  && /opt/bitnami/php/bin/phpize && ./configure  --with-php-config=/opt/bitnami/php/bin/php-config \
  && make -j32 \
  && make install \
  && echo 'extension=opentelemetry.so' >> /opt/bitnami/php/etc/php.ini \
  && cd .. \
  && rm -rf ./opentelemetry-1.1.2* \
  && wget https://pecl.php.net/get/protobuf-4.29.3.tgz \
  && tar xzf protobuf-4.29.3.tgz \
  && cd protobuf-4.29.3 \
  && /opt/bitnami/php/bin/phpize && ./configure  --with-php-config=/opt/bitnami/php/bin/php-config \
  && make -j32 \
  && make install \
  && echo 'extension=protobuf.so' >> /opt/bitnami/php/etc/php.ini \
  && cd .. \
  && rm -rf ./protobuf-4.29.3* \
  && git clone https://github.com/adsr/phpspy.git \
  && cd phpspy \
  && make -j32 \
  && make install \
  && cd .. \
  && rm -rf ./phpspy \
  && wget https://go.dev/dl/go1.24.0.linux-amd64.tar.gz \
  && tar -C /tmp -xzf go1.24.0.linux-amd64.tar.gz \
  && git clone https://github.com/beertje44/phpScope \
  && cd phpScope \
  && /tmp/go/bin/go mod download \
  && CGO_ENABLED=0 GOOS=linux /tmp/go/bin/go build -o phpscope . \
  && mv phpscope /usr/local/bin \
  && chmod 755 /usr/local/bin/phpscope \
  && cd .. \
  && rm -rf ./phpScope \
  && rm -rf ./go* \
  && apt-get autoremove --purge -y autoconf wget build-essential git

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/nginx/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/nginx-php-fpm/postunpack.sh
RUN /opt/bitnami/scripts/wordpress/postunpack.sh
RUN /opt/bitnami/wp-cli/bin/wp package install wp-cli/doctor-command:@stable --allow-root \
  && cd /bitnami \
  && /opt/bitnami/php/bin/php /usr/bin/composer require \
    open-telemetry/sdk \
    open-telemetry/exporter-otlp \
    open-telemetry/opentelemetry-auto-wordpress \
    open-telemetry/opentelemetry-auto-psr15 \
    open-telemetry/opentelemetry-auto-psr18 \
    guzzlehttp/guzzle \
    guzzlehttp/psr7 \
    vlucas/phpdotenv \
  && echo "auto_prepend_file=/bitnami/wordpress/autoload.php" >> /opt/bitnami/php/etc/php.ini \
  && echo -e "\nenv[LANG] = \$LANG" >> /opt/bitnami/php/etc/environment.conf
ENV APP_VERSION="6.7.2" \
    BITNAMI_APP_NAME="wordpress-nginx" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/nginx/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/wp-cli/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wordpress/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]
