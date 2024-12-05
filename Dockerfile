# Use the latest PHP base image
FROM php:latest

# Set working directory
WORKDIR /var/www/html

# Update package list
RUN apt-get update

# Install Nano
RUN apt-get install -y --no-install-recommends nano

# Install Cron
RUN apt-get install -y --no-install-recommends cron

# Install Unzip
RUN apt-get install -y --no-install-recommends unzip

# Install Zip
RUN apt-get install -y --no-install-recommends zip

# Install libzip-dev
RUN apt-get install -y --no-install-recommends libzip-dev

# Install libjpeg-dev
RUN apt-get install -y --no-install-recommends libjpeg-dev

# Install libpng-dev
RUN apt-get install -y --no-install-recommends libpng-dev

# Install libxml2-dev
RUN apt-get install -y --no-install-recommends libxml2-dev

# Install libcurl4-openssl-dev
RUN apt-get install -y --no-install-recommends libcurl4-openssl-dev

# Install zlib1g-dev
RUN apt-get install -y --no-install-recommends zlib1g-dev

# Install mbstring dependencies
RUN apt-get install -y --no-install-recommends libonig-dev

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-install intl
RUN docker-php-ext-install exif
RUN docker-php-ext-install opcache
RUN docker-php-ext-install curl

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN echo "date.timezone = Europe/Berlin" > /usr/local/etc/php/conf.d/timezone.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create Cron folder and set permissions
RUN mkdir -p /var/spool/cron/crontabs && chmod -R 600 /var/spool/cron/crontabs

# Set Cron TZ to Europe/Berlin
RUN echo "SHELL=/bin/sh\nCRON_TZ=Europe/Berlin" > /etc/crontab

# Default to Cron in foreground
CMD ["cron", "-f"]

# Set TTY environment variables
ENV TTY=true
ENV STDIN_OPEN=true
