FROM debian:jessie
MAINTAINER piotr.figlarek@gmail.com

# environment for osticket
ENV OSTICKET_VERSION 1.10

# requirements
RUN apt-get update && \
    apt-get -y install wget unzip apache2 libapache2-mod-php5 php5-cli php5-fpm php5-imap php5-gd php5-mysql php5-intl php5-apcu 

# Let's set the default timezone in both cli and apache configs
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Warsaw/g' /etc/php5/cli/php.ini
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Warsaw/g' /etc/php5/apache2/php.ini

# Download & install OSTicket
RUN wget http://osticket.com/sites/default/files/download/osTicket-v${OSTICKET_VERSION}.zip -O /tmp/osTicket.zip
RUN unzip /tmp/osTicket.zip -d /tmp/osTicket
RUN rm /var/www/html/index.html
RUN cp -rv /tmp/osTicket/upload/* /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

# Cleanup
RUN rm -r /tmp/osTicket.zip
RUN rm -rf /tmp/osTicket

# Download languages packs
RUN cd /var/www/html/include/i18n && \
    wget http://osticket.com/sites/default/files/download/lang/cs.phar && \
    wget http://osticket.com/sites/default/files/download/lang/da.phar && \
    wget http://osticket.com/sites/default/files/download/lang/de.phar && \
    wget http://osticket.com/sites/default/files/download/lang/fr.phar && \
    wget http://osticket.com/sites/default/files/download/lang/hu.phar && \
    wget http://osticket.com/sites/default/files/download/lang/it.phar && \
    wget http://osticket.com/sites/default/files/download/lang/nl.phar && \
    wget http://osticket.com/sites/default/files/download/lang/pl.phar && \
    wget http://osticket.com/sites/default/files/download/lang/sk.phar && \
    wget http://osticket.com/sites/default/files/download/lang/fi.phar && \
    wget http://osticket.com/sites/default/files/download/lang/sv_SE.phar && \
    wget http://osticket.com/sites/default/files/download/lang/ru.phar && \
    wget http://osticket.com/sites/default/files/download/lang/uk.phar

# Initialize config file
RUN mv /var/www/html/include/ost-sampleconfig.php /var/www/html/include/ost-config.php

EXPOSE 80

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

