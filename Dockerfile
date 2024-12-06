# Verwende ein leichtes Linux-Image mit apt (Debian Slim als Basis)
FROM debian:bookworm-slim

# Setze das Arbeitsverzeichnis
WORKDIR /var/www/html

# Aktualisiere Paketlisten und installiere grundlegende Abhängigkeiten
RUN apt-get update && apt-get install -y \
    php-cli \
    php-mysql \
    php-mbstring \
    php-zip \
    php-gd \
    php-intl \
    php-exif \
    php-opcache \
    php-curl \
    php-xml \
    php-bcmath \
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
    sudo \
    curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Installiere Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Setze die Zeitzone
RUN echo "date.timezone = Europe/Berlin" > /etc/php/8.0/cli/conf.d/99-timezone.ini

# Erstelle Cron-Verzeichnisse und setze Berechtigungen
RUN mkdir -p /var/spool/cron/crontabs && chmod -R 600 /var/spool/cron/crontabs

# Füge Standard-Crontab-Konfiguration hinzu
RUN echo "SHELL=/bin/sh\nCRON_TZ=Europe/Berlin" > /etc/crontab

# Füge Standard-PHP-Konfiguration hinzu
RUN echo "memory_limit = 256M" > /etc/php/8.0/cli/conf.d/99-custom.ini

# Setze den Standardbefehl für Cron im Vordergrund
CMD ["cron", "-f"]

# TTY- und STDIN-Umgebungsvariablen
ENV TTY=true
ENV STDIN_OPEN=true
