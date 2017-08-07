FROM ubuntu
MAINTAINER DF
LABEL Description="Web App basado el PHP APACHE y MARIDB como base ubuntu"

RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get install -y \
	php \
	php-bz2 \
	php-cgi \
	php-cli \
	php-common \
	php-curl \
	php-dev \
	php-enchant \
	php-fpm \
	php-gd \
	php-gmp \
	php-imap \
	php-interbase \
	php-intl \
	php-json \
	php-ldap \
	php-mcrypt \
	php-mysql \
	php-odbc \
	php-opcache \
	php-pgsql \
	php-phpdbg \
	php-pspell \
	php-readline \
	php-recode \
	php-snmp \
	php-sqlite3 \
	php-sybase \
	php-tidy \
	php-xmlrpc \
	php-xsl
RUN apt-get install apache2 libapache2-mod-php -y
RUN apt-get install mariadb-common mariadb-server mariadb-client -y
RUN apt-get install nano tree vim curl ftp git -y
RUN echo "postfix postfix/mailname string example.com" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
RUN apt-get install postfix -y

ENV DATE_TIMEZONE America/Guayaquil
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www/html/glpi
ENV MARIDB_DB /var/lib/mysql

RUN mkdir $APACHE_DOCUMENTROOT && git clone https://github.com/glpi-project/glpi.git $APACHE_DOCUMENTROOT
ADD start-glpi.sh /usr/sbin/
ADD glpi.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled/

RUN chmod +x /usr/sbin/start-glpi.sh
RUN chown -R www-data:www-data /var/www/html

VOLUME $APACHE_DOCUMENTROOT
VOLUME $MARIDB_DB
VOLUME /var/log/httpd
VOLUME /var/log/mysql

EXPOSE 80
EXPOSE 3306

CMD ["/usr/sbin/start-glpi.sh"]
