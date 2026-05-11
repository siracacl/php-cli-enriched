FROM php:latest

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/html

# ---------------------------------------------------------------------
# System packages
# ---------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        nano \
        git \
        unzip \
        zip \
        net-tools \
        libzip-dev \
        libjpeg-dev \
        libpng-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        zlib1g-dev \
        libonig-dev \
        libpq-dev \
        imagemagick \
        libmagickwand-dev \
        python3-full \
        python3-dev \
        python3-pip \
        python3-venv \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------
# Python venv for weekly-report forecasting (numpy + statsmodels)
# Path is hardcoded in weekly-report/forecaster.php and forecast.py
# ---------------------------------------------------------------------
RUN python3 -m venv /opt/forecast-env \
    && /opt/forecast-env/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/forecast-env/bin/pip install --no-cache-dir numpy statsmodels

# ---------------------------------------------------------------------
# PHP extensions (built-in)
# Note: curl, mbstring, opcache are already in php:latest base image
# ---------------------------------------------------------------------
RUN docker-php-ext-install \
        pdo_mysql \
        mysqli \
        zip \
        gd \
        intl \
        exif \
        pdo_pgsql \
        pgsql

# ---------------------------------------------------------------------
# PHP extensions (PECL)
# ---------------------------------------------------------------------
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# ---------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------
RUN echo "date.timezone = Europe/Berlin" > /usr/local/etc/php/conf.d/timezone.ini

# ---------------------------------------------------------------------
# Composer
# ---------------------------------------------------------------------
RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer

# ---------------------------------------------------------------------
# Runtime
# ---------------------------------------------------------------------
ENV TTY=true
ENV STDIN_OPEN=true

CMD ["php", "-a"]