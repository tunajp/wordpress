FROM wordpress:latest

# install composer
RUN cd /usr/bin && curl -s http://getcomposer.org/installer | php && ln -s /usr/bin/composer.phar /usr/bin/composer
# install wp-cli
RUN cd /usr/bin &&  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x /usr/bin/wp-cli.phar && ln -s /usr/bin/wp-cli.phar /usr/bin/wp

# install nodejs
RUN apt-get update \
  && apt-get install -my wget gnupg
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN curl -SL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install -y nodejs

# install tools
RUN apt-get update \
&& apt-get install -y \
git \
zip \
unzip \
vim

# install php extentions
RUN apt-get update \
    && apt-get install -y libpq-dev \
    && apt-get install -y zlib1g-dev libicu-dev g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl pdo_mysql pdo_pgsql

# mailtodisk
COPY ./sendmail.ini /usr/local/etc/php/conf.d/
COPY ./mailtodisk /usr/bin/
RUN chmod +x /usr/bin/mailtodisk

# php.iniの追記
COPY ./maxupload.ini /usr/local/etc/php/conf.d/

# SSL
#RUN apt-get install -y apache2
RUN a2enmod ssl
COPY ./ssl.conf /etc/apache2/sites-available/ssl.conf
COPY ./server.key /etc/apache2/server.key
COPY ./server.crt /etc/apache2/server.crt
RUN a2ensite ssl

# sudo
RUN apt-get update && \
      apt-get -y install sudo
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

Workdir /var/www/html
#CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]