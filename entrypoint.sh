#!/bin/bash

CRON_FILE="/etc/cron.d/osticket"

if [ -f /tmp/ost-config/ost-config.php  ]; then
  cp /tmp/ost-config/ost-config.php /var/www/html/include/ost-config.php
  chown www-data /var/www/html/include/ost-config.php
fi

if [ -d /var/www/html/setup/ ]; then
  rm -R /var/www/html/setup
fi

if [ ! -f $CRON_FILE ]; then
  echo "Setup Cron-Job for OsTicket ($CRON_FILE)"
  echo  "*/3 * * * * root /usr/bin/php -c /etc/php/7.3/cli/php.ini /var/www/html/api/cron.php" > $CRON_FILE
  echo  "#blank line" >> $CRON_FILE
  chmod 600 $CRON_FILE
fi

# cron
echo "Starting cron"
/usr/sbin/cron

source /etc/apache2/envvars && /usr/sbin/apache2 -DFOREGROUND

