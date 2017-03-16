#!/bin/bash

datetimestamp=`date +%Y-%m-%d_%Hh%Mm`

CONFIG_mysql_dump_username=root
CONFIG_mysql_dump_password='pass'
CONFIG_mysql_dump_host=127.0.0.1
NODE_NAME=vagrant
WORK_DIR=/home/vagrant/backup
DBS=(mysql test)

for db in ${DBS[@]}; do
	dirname=/Apps/${NODE_NAME}/`date +%Y`/`date +%m`/`date +%d`
	FILE=${WORK_DIR}/${db}.${datetimestamp}.sql.tar.gz
	mysqldump --single-transaction  --user=${CONFIG_mysql_dump_username} --password=${CONFIG_mysql_dump_password} --host=${CONFIG_mysql_dump_host}  ${db} | gzip > ${FILE}
	sha1sum ${FILE} | awk '{print $1}' > ${FILE}.sha1
        /opt/dropbox_uploader.sh upload ${FILE} ${dirname}/${db}.${datetimestamp}.sql.tar.gz
	/opt/dropbox_uploader.sh upload ${FILE}.sha1 ${dirname}/${db}.${datetimestamp}.sql.tar.gz.sha1
done

