# Definição da imagem da docker que será utilizada
# Apache com PHP 7.4
FROM ubuntu:latest

# Criação do diretório do vHost
RUN mkdir -p /var/www/prd
RUN mkdir -p /var/www/dev

# Definição de permissões no diretório do vHost
RUN chmod -R 777 /var/www/prd
RUN chmod -R 777 /var/www/dev

# Definição do proprietário no diretório do vHost
# Se faz necessário para o apache conseguir ler e escrever no diretório
RUN chown www-data:www-data /var/www/prd
RUN chown www-data:www-data /var/www/dev

# Copia arquivos para execução da docker
COPY /web/config /

# Define permissões dos arquivos SH
RUN chmod 777 -R /usr/local/bin
RUN chmod 777 -R /tmp

# Variáveis de ambiente
ENV COMPOSER_ALLOW_SUPERUSER=1

# Desativa frontend
ENV DEBIAN_FRONTEND=noninteractive

# Instalações de bibliotecas no linux
RUN apt-get update && apt-get install -y apache2 \
    git \
    libmcrypt-dev \
    libbz2-dev \
    zlib1g-dev \
    zip \
    libzip-dev \
    curl \
    libcurl4-openssl-dev \
    libonig-dev \
    libpng-dev \
    libmemcached-dev \
    libxml2-dev \
    libxslt1-dev \
    tzdata \
    software-properties-common \
    cron \
    wget \
    certbot

# Variável com a timezone
ENV TZ=America/sao_Paulo

# Adiciona repositório do PHP
RUN add-apt-repository ppa:ondrej/php

# Realiza o update
RUN apt-get update

# Instalação das extensões do PHP
RUN apt-get install -y php7.4
RUN apt-get install -y php7.4-gd \
     php7.4-mysqli \
     php7.4-pdo \
     php7.4-imap \
     php7.4-curl \
     php7.4-intl \
     php7.4-xmlrpc \
     php7.4-xsl \
     php7.4-zip \
     php7.4-mbstring \
     php7.4-soap \
     php7.4-opcache \
     php7.4-common \
     php7.4-json \
     php7.4-readline \
     php7.4-xml \
     php7.4-bz2 \
     php7.4-fileinfo \
     php7.4-gettext \
     php7.4-exif \
     php7.4-mcrypt \
     php7.4-xmlwriter \
     php7.4-xmlreader \
     php7.4-cli \
     php7.4-fpm \
     php7.4-bcmath

# Instalação do composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && php -r "unlink('composer-setup.php');" && mv composer.phar /usr/local/bin/composer

# Instalação do IonCube
RUN sh /tmp/scripts/extension-ioncube-install.sh

# Ativa configurações do apache
RUN a2enmod actions alias proxy_fcgi

# Ativação do mod_rewrite e mod_headers
RUN a2enmod ssl proxy_ajp proxy_http rewrite deflate headers proxy_balancer proxy_connect proxy_html

# Ativação das variáveis do apache
RUN a2enconf env-vars

# Copia arquivo de configurações do PHP
COPY /web/php_ioncube.ini /etc/php/7.4/apache2/conf.d/0-ioncube.ini
COPY /web/php.ini /etc/php/7.4/apache2/conf.d/web_padrao.ini

# Inativa site padrão
#RUN a2dissite 000-default.conf

# Ativação da vHost
#RUN a2ensite 2ri api dev dev-api-indicador dev-indicador api-indicador indicador konga

# Executa script
CMD /usr/local/bin/start.sh
