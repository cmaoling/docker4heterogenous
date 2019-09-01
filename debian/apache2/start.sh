#!/bin/bash

# Start apache
apache2ctl configtest
#apache2ctl start
/usr/sbin/apache2 -D FOREGROUND
