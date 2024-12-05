# Verwende das neueste PHP-Basisimage
FROM php:latest

# Setze das Arbeitsverzeichnis
WORKDIR /var/www/html

# Update der Paketliste
RUN apt-get update

# Installation von Nano
RUN apt-get install -y --no-install-recommends nano

# Installation von Cron
RUN apt-get install -y --no-install-recommends cron

# Installation von Unzip
RUN apt-get install -y --no-install-recommends unzip

# Installation von Zip
RUN apt-get install -y --no-install-recommends zip

# Installation von libzip-dev
RUN apt-get install -y --no-install-recommends libzip-dev

# Installation von libjpeg-dev
RUN apt-get install -y --no-install-recommends libjpeg-dev

# Installation von libpng-dev
RUN apt-get install -y --no-install-recommends libpng-dev

# Installation von libxml2-dev
RUN apt-get install -y --no-install-recommends libxml2-dev

# Installation von libcurl4-openssl-dev
RUN apt-get install -y --no-install-recommends libcurl4-openssl-dev

# Installation von zlib1g-dev
RUN apt-get install -y --no-install-recommends zlib1g-dev

# Installation der PHP-Erweiterungen
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-install intl
RUN docker-php-ext-install exif
RUN docker-php-ext-install opcache
RUN docker-php-ext-install curl

# Aufräumen nach der Installation
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

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

# Umgebungsvariablen für TTY
ENV TTY=true
ENV STDIN_OPEN=true
