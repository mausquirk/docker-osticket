#!/bin/bash

source /etc/apache2/envvars &&  /usr/sbin/apache2 -DFOREGROUND
# exec apache2ctl -D FOREGROUND
# exec /etc/init.d/apache2 start

# exec apache2 -D FOREGROUND

