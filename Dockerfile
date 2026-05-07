FROM php:latest

# Avoid interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/html

# ---------------------------------------------------------------------
# System packages (PHP build deps + tooling + Python)
# ---------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        # Editing & version control
        nano \
        git \
        # Archive tools
        unzip \
        zip \
        # Networking diagnostics
        net-tools \
        # PHP extension build dependencies
        libzip-dev \
        libjpeg-dev \
        libpng-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        zlib1g-dev \
        libonig-dev \
        libpq-dev \
        # Imagick
        imagemagick \
        libmagickwand-dev \
        # Python toolchain (for scripts using python3)
        python3-full \
        python3-dev \
        python3-pip \
        python3-venv \
        # General build tooling
        build-essential \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------
# PHP extensions (built-in)
# ---------------------------------------------------------------------
RUN docker-php-ext-install \
        pdo_mysql \
        mysqli \
        mbstring \
        zip \
        gd \
        intl \
        exif \
        opcache \
        curl \
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
