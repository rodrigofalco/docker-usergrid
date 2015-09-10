#!/bin/bash
#
# Based on https://github.com/tutumcloud/tutum-docker-tomcat
#

if [ ! -f ${TOMCAT_CONFIGURATION_FLAG} ]; then
    /usergrid/create_tomcat_admin_user.sh
fi
JAVA_OPTS="-Djava.library.path=/usr/local/apr/lib -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC"
exec /usr/share/tomcat7/bin/catalina.sh run
