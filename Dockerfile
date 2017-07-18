FROM debian:lastes

MAINTAINER  Darwin Adriano adriandafer@gmail.com

RUN apt-get update -y && apt-get dist-upgrade -yqq

RUN apt-get install -y php-cli php  php-mcrypt php-curl php-mysql
RUN apt-get install -y openss-server supervisor
RUN mkdir -p /var/run/sshd

#config usuario ssh
RUN useradd -d  /home/glpi -m -s /gin/bash glpi
RUN echo glpi:glpi | passwd
RUN usermod -aG sudo glpi
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin no' /etc/ssh/sshd_config

#configuracion supervisor
RUN mkdir -p /var/log/supervisor
COPY ./supervisord.conf /etc/supervisor/supervisord.conf

#configuracion apache
COPY ./glpi.conf /etc/apache2/sites-avaible/
RUN ln -s /etc/apache2/sites-avaible/glpi.conf /etc/apache2/sites-enabled/

#variable del entorno DOCKER para apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www/html


EXPOSE 80 22
COPY .scripts/info.php /var/www/html/info.php
CMD ["/usr/bin/supervisord","c", "/etc/supervisor/supervisord.conf"]


