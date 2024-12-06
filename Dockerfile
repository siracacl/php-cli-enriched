# Use Ubuntu 24.04 LTS as the base image
FROM ubuntu:24.04

# Set the working directory
WORKDIR /var/www/html

# Update package lists and install core dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \  # Allows adding PPAs
    curl \                        # Required for downloading additional tools
    apt-transport-https \         # Enables HTTPS support for apt
    sudo \                        # Allows using sudo commands
    unzip \                       # Required for handling .zip files
    zip \                         # Compression tool
    nano \                        # Lightweight text editor
    cron \                        # Cron job support
    libzip-dev \                  # Required for ZIP operations
    libjpeg-dev \                 # JPEG image library
    libpng-dev \                  # PNG image library
    libxml2-dev \                 # XML processing library
    libcurl4-openssl-dev \        # cURL library
    zlib1g-dev \                  # Compression library
    systemctl && \                # Systemd service manager
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add the PPA for PHP 8.4 and install PHP with required extensions
RUN add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y \
    php8.4-cli \                 # PHP Command Line Interface
    php8.4-mysql \               # MySQL support for PHP
    php8.4-mbstring \            # Multibyte string support
    php8.4-zip \                 # ZIP file handling
    php8.4-gd \                  # Image processing
    php8.4-intl \                # Internationalization support
    php8.4-opcache \             # Opcode cache for performance
    php8.4-curl \                # cURL support for API calls
    php8.4-xml \                 # XML handling
    php8.4-bcmath \              # Arbitrary precision math
    php8.4-soap \                # SOAP extension
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer for dependency management
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure PHP timezone
RUN echo "date.timezone = Europe/Berlin" > /etc/php/8.4/cli/conf.d/99-timezone.ini

# Create cron directories and set permissions
RUN mkdir -p /var/spool/cron/crontabs && chmod -R 600 /var/spool/cron/crontabs

# Add default crontab configuration
RUN echo "SHELL=/bin/sh\nCRON_TZ=Europe/Berlin" > /etc/crontab

# Add custom PHP configuration
RUN echo "memory_limit = 256M" > /etc/php/8.4/cli/conf.d/99-custom.ini

# Enable systemd and cron service
RUN apt-get install -y systemd && \
    systemctl enable cron

# Default command: Bash
CMD ["/bin/bash"]

# TTY and STDIN environment variables for container interaction
ENV TTY=true
ENV STDIN_OPEN=true
