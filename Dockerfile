FROM debian:buster
MAINTAINER maurus.frey@innetag.ch

# environment for osticket
ENV OSTICKET_VERSION  1.14.2 

# requirements
RUN apt-get update && \
    apt-get -y install wget unzip apache2 libapache2-mod-php7.3 php7.3-cli php7.3-imap php7.3-gd php7.3-mysql php7.3-intl php7.3-apcu php7.3-xml php7.3-mbstring sendmail cron

# Let's set the default timezone in both cli and apache configs
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Warsaw/g' /etc/php/7.3/cli/php.ini
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Warsaw/g' /etc/php/7.3/apache2/php.ini

# Download & install OSTicket
RUN wget -nv https://github.com/osTicket/osTicket/releases/download/v${OSTICKET_VERSION}/osTicket-v${OSTICKET_VERSION}.zip -O /tmp/osTicket.zip
RUN unzip /tmp/osTicket.zip -d /tmp/osTicket && \
	rm /var/www/html/index.html && \
	cp -rv /tmp/osTicket/upload/* /var/www/html/ && \
	chown -R www-data:www-data /var/www/html/

# Cleanup
RUN rm -r /tmp/osTicket.zip && \
    rm -rf /tmp/osTicket

# Download languages packs
RUN cd /var/www/html/include/i18n && \
 wget -nv https://s3.amazonaws.com/downloads.osticket.com/lang/fr.phar && \
 wget -nv https://s3.amazonaws.com/downloads.osticket.com/lang/ar.phar && \
 wget -nv https://s3.amazonaws.com/downloads.osticket.com/lang/pt_BR.phar && \
    wget -nv https://s3.amazonaws.com/downloads.osticket.com/lang/it.phar && \
    wget -nv https://s3.amazonaws.com/downloads.osticket.com/lang/es_ES.phar && \
    wget -nv https://s3.amazonaws.com/downloads.osticket.com/lang/de.phar 

# Prepare the volume for the config file
RUN mkdir /tmp/ost-config
VOLUME /tmp/ost-config
VOLUME /var/www/html/include/plugins

# set upload limit to 60MB
RUN touch /etc/php/7.3/apache2/conf.d/20-uploads.ini \
    && echo "upload_max_filesize = 90M;" >> /etc/php/7.3/apache2/conf.d/20-uploads.ini

# Pipe logs 
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

EXPOSE 80

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

