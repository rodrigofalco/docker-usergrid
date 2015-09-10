############################################################
# Dockerfile to run Apache usergrid_
# Based on gaborwnuk/usergrid mixed with pushion baseimage
############################################################

#  http://phusion.github.io/baseimage-docker/
#
# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.17

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...


# Set the base image to use to Ubuntu
#FROM ubuntu

MAINTAINER Rodrigo Falco <rodrigo@patagonian.it>

ENV TOMCAT_CONFIGURATION_FLAG /usergrid/.tomcat_admin_created

RUN mkdir /usergrid
WORKDIR /usergrid

RUN apt-get update ; apt-get install -y wget pwgen openjdk-7-jdk tomcat7

#
# Configure basic stuff, nothing important.
#
ADD create_tomcat_admin_user.sh /usergrid/create_tomcat_admin_user.sh
ADD run.sh /usergrid/run.sh
RUN chmod +x /usergrid/*.sh
RUN ln -s /etc/tomcat7/ /usr/share/tomcat7/conf

#
# Just to suppress tomcat warnings.
#
RUN mkdir -p /usr/share/tomcat7/common/classes; \
mkdir -p /usr/share/tomcat7/server/classes; \
mkdir -p /usr/share/tomcat7/shared/classes; \
mkdir -p /usr/share/tomcat7/webapps; \
mkdir -p /usr/share/tomcat7/temp

#
# Deploy WAR
#
ADD ROOT.war /usr/share/tomcat7/webapps/ROOT.war

RUN ln -s /usr/share/tomcat7/webapps/ /etc/tomcat7/webapps

#
# Port to expose (default for tomcat: 8080)
#
EXPOSE 8080

#ENTRYPOINT ./run.sh

# Configure tomcat to start
### In Dockerfile:
RUN mkdir /etc/service/usergrid
ADD run.sh /etc/service/usergrid/run
RUN chmod +x /etc/service/usergrid/run

# Rfalco: Fix digiytal ocean slow tomcat start
# http://stackoverflow.com/questions/26431922/tomcat7-starts-too-late-on-ubuntu-14-04-x64-digitalocean
ADD java.security /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/java.security

# Added rfalco
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
