FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y curl zip unzip php-fpm php-cli php-mysql php-gd php-curl nginx
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./config/nginx.conf /etc/nginx/
COPY ./config/default.conf /etc/nginx/conf.d/
COPY ./config/php/php.ini /etc/php/8.1/fpm/
COPY ./config/php/www.conf /etc/php/8.1/fpm/pool.d/

COPY ./src/ /var/www/html/
WORKDIR /var/www/html/
RUN composer install

RUN chown -R www-data:www-data /var/www/html

CMD php-fpm8.1 && nginx -g "daemon off;"
