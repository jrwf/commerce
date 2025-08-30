FROM php:8.3-apache

# Definování uživatele a skupiny pro aplikaci
ARG WWWGROUP=1000
ARG WWWUSER=1000
ARG GIT_USER_EMAIL=jiri.wolf@jw.cz
ARG GIT_USER_NAME=Wolf
# Node.js verze
ARG NODE_VERSION=20.x

# Vytvoření uživatele a skupiny (ponecháno, i když docker-compose.yml přebírá řízení uživatele)
RUN set -eux; \
    groupadd -g ${WWWGROUP} www-data || true; \
    useradd -u ${WWWUSER} -ms /bin/bash www-data -g www-data || true

WORKDIR /var/www/html

# Instalace systémových závislostí a PHP rozšíření
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    git \
    wget \
    curl \
    gnupg \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install \
    gd \
    intl \
    opcache \
    pdo \
    pdo_mysql \
    mysqli \
    zip \
    && a2enmod rewrite \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalace Node.js a npm
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm --version \
    && node --version \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Nastavte npm, aby používal adresář uvnitř /var/www/html pro cache.
# Oprávnění pro tento adresář jsou řešena v entrypointu docker-compose.yml.
RUN npm config set cache /var/www/html/.npm-cache --global

# Instalace Composer
RUN wget https://getcomposer.org/installer -O composer-setup.php \
    && php --define "suhosin.executor.include.whitelist=phar" composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# Instalace Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Nastavení prostředí
ENV PHP_IDE_CONFIG="serverName=d11-app"
# Composer vendor bin by měl být v PATH automaticky, pokud je composer nainstalován do /usr/local/bin
# Pokud by byl problém, tuto řádku je možné vrátit, ale pak je třeba zajistit, aby /home/www-data existovalo
# ENV PATH=$PATH:/home/www-data/.composer/vendor/bin

# Git konfigurace (z build argumentů)
RUN git config --global user.email "${GIT_USER_EMAIL}" \
    && git config --global user.name "${GIT_USER_NAME}" \
    && git config --global init.defaultBranch master \
    && git config --global --add safe.directory /var/www/html

# Vytvoření symbolického odkazu na Drush
# Drush se obvykle instaluje do vendor/bin, takže by měl být dostupný, pokud je vendor/bin v PATH
RUN ln -s /var/www/html/vendor/bin/drush /usr/local/bin/drush

# Nastavení vlastnictví adresáře (jako root) - důležité, aby základní soubory byly vlastněny www-data
# i když user v docker-compose.yml to může přepsat. Apache stále běží pod www-data.
RUN chown -R www-data:www-data /var/www/html

# Odstraněno: Přepnutí na uživatele www-data pro běh aplikace, protože uživatel je definován v docker-compose.yml
# USER www-data

CMD ["apache2-foreground"]