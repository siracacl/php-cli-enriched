# most recent php image
FROM php:latest

# workdir
WORKDIR /var/www/html

# install steroids
RUN apt-get update && apt-get install -y \
    nano \
    cron \
    net-tools \
    iputils-ping \
    git \
    unzip \
    zip \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libsqlite3-dev \
    libmcrypt-dev \
    libicu-dev \
    g++ \
    zlib1g-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    pdo_sqlite \
    mysqli \
    mbstring \
    zip \
    gd \
    opcache \
    intl \
    exif \
    bcmath \
    calendar \
    soap \
    pcntl \
    sockets \
    gettext \
    shmop \
    sysvsem \
    sysvshm \
    sysvmsg \
    xml \
    tokenizer \
    json \
    curl \
    && pecl install redis xdebug \
    && docker-php-ext-enable redis xdebug \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set Europe/Berlin TZ
RUN echo "date.timezone = Europe/Berlin" > /usr/local/etc/php/conf.d/timezone.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create cron directory
RUN mkdir -p /var/spool/cron/crontabs && chmod -R 600 /var/spool/cron/crontabs

# Cron TZ Europe/Berlin
RUN echo "SHELL=/bin/sh\nCRON_TZ=Europe/Berlin" > /etc/crontab

# CMD
CMD ["bash"]

# Config tty
ENV TTY=true
ENV STDIN_OPEN=true
