# Production-like PHP + Apache image that mirrors the existing XAMPP stack
FROM php:8.2-apache

# Install system dependencies and PHP extensions required by the app
RUN apt-get update \
    && apt-get install -y \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        libzip-dev \
        unzip \
        git \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install gd mysqli pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Enable useful Apache modules for the application
RUN a2enmod rewrite headers

# Set the Apache document root to the PHP application directory
ENV APACHE_DOCUMENT_ROOT=/var/www/html
WORKDIR ${APACHE_DOCUMENT_ROOT}

# Copy the application source into the image
COPY customer_support/ ${APACHE_DOCUMENT_ROOT}/

# Ensure the web server can write to storage directories (e.g., uploads)
RUN chown -R www-data:www-data ${APACHE_DOCUMENT_ROOT}

EXPOSE 80

# Default Apache + PHP entrypoint provided by the base image
CMD ["apache2-foreground"]
