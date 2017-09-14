FROM php:5.6.31-apache

RUN apt-get update && apt-get install -y \
    php-pear \
    php5-cli \
    php5-mysql \
    curl \
    git zip unzip

RUN mkdir -p /home/app/
ADD . /home/app/

WORKDIR /home/app

RUN curl -sS https://getcomposer.org/installer | php -d allow_url_fopen=on
RUN php -d allow_url_fopen=on ./composer.phar install
RUN chown -R www-data:www-data /home/app

ENV APACHE_DOCUMENT_ROOT /home/app/html

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

ADD Specific/virtualhosts/baikal.apache2 /etc/apache2/sites-enabled/000_default.conf

CMD docker/bin/config.sh
