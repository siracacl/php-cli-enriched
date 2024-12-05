# Most recent PHP image
FROM php:latest

# Workdir
WORKDIR /var/www/html

# Install basic tools and dependencies
RUN apt-get update && apt-get install -y \
    nano \
    cron \
    unzip \
    zip \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    mysqli \
    mbstring \
    zip \
    gd \
    intl \
    exif \
    opcache \
    curl \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set Europe/Berlin TZ
RUN echo "date.timezone = Europe/Berlin" > /usr/local/etc/php/conf.d/timezone.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create cron directory
RUN mkdir -p /var/spool/cron/crontabs && chmod -R 600 /var/spool/cron/crontabs

# Set Cron TZ to Europe/Berlin
RUN echo "SHELL=/bin/sh\nCRON_TZ=Europe/Berlin" > /etc/crontab

# Set CMD
CMD ["bash"]

# Config tty
ENV TTY=true
ENV STDIN_OPEN=true
