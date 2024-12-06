# Use Ubuntu 24.04 LTS as the base image
FROM ubuntu:24.04

# Set the working directory
WORKDIR /var/www/html

# Update the package list and install required dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

# Add the Ondřej PHP PPA
RUN add-apt-repository ppa:ondrej/php -y

# Update the package list again
RUN apt-get update

# Install PHP and required extensions
RUN apt-get install -y \
    php8.4 \
    php8.4-cli \
    php8.4-mysql \
    php8.4-mbstring \
    php8.4-zip \
    php8.4-gd \
    php8.4-intl \
    php8.4-exif \
    php8.4-opcache \
    php8.4-curl \
    php8.4-xml \
    php8.4-bcmath \
    php8.4-soap

# Install additional tools
RUN apt-get install -y \
    cron \
    nano \
    unzip \
    zip \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libonig-dev \
    sudo

# Clean up unnecessary files to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the timezone
RUN echo "date.timezone = Europe/Berlin" > /etc/php/8.4/cli/conf.d/99-timezone.ini

# Create Cron directories and set permissions
RUN mkdir -p /var/spool/cron/crontabs
RUN chmod -R 600 /var/spool/cron/crontabs

# Add default Crontab configuration
RUN echo "SHELL=/bin/sh\nCRON_TZ=Europe/Berlin" > /etc/crontab

# Add custom PHP configuration
RUN echo "memory_limit = 256M" > /etc/php/8.4/cli/conf.d/99-custom.ini

# Copy the crontab file into the container
COPY crontab /etc/cron.d/custom-cron

# Set permissions for the crontab file
RUN chmod 0644 /etc/cron.d/custom-cron

# Apply the crontab
RUN crontab /etc/cron.d/custom-cron

# Set the default command to run Cron in the foreground
CMD ["cron", "-f"]

# Set TTY and STDIN environment variables
ENV TTY=true
ENV STDIN_OPEN=true
