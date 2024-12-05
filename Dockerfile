# Verwende das neueste PHP-Basisimage
FROM php:latest

# Setze das Arbeitsverzeichnis
WORKDIR /var/www/html

# Installiere grundlegende Tools und PHP-Erweiterungen
RUN apt-get update && apt-get install -y --no-install-recommends \
    nano \
    cron \
    unzip \
    zip \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Setze die Zeitzone
RUN echo "date.timezone = Europe/Berlin" > /usr/local/etc/php/conf.d/timezone.ini

# Installiere Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Cron-Ordner anlegen und Rechte setzen
RUN mkdir -p /var/spool/cron/crontabs && chmod -R 600 /var/spool/cron/crontabs

# Setze Cron TZ auf Europe/Berlin
RUN echo "SHELL=/bin/sh\nCRON_TZ=Europe/Berlin" > /etc/crontab

# CMD standardmäßig auf bash setzen
CMD ["bash"]

# Umgebungsvariablen für TTY (optional, je nach Umgebung)
ENV TTY=true
ENV STDIN_OPEN=true
