#!/bin/sh
set -e
set -x

sed -ier "/PROJECT_DB_MYSQL_DBNAME/s/'[^']*'/'${DB_NAME}'/2" /home/app/Specific/config.system.php
sed -ier "/PROJECT_DB_MYSQL_HOST/s/'[^']*'/'${DB_HOST}'/2" /home/app/Specific/config.system.php
sed -ier "/PROJECT_DB_MYSQL_USERNAME/s/'[^']*'/'${DB_USERNAME}'/2" /home/app/Specific/config.system.php
sed -ier "/PROJECT_DB_MYSQL_PASSWORD/s/'[^']*'/'${DB_PASSWORD}'/2" /home/app/Specific/config.system.php
