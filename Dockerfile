FROM ubuntu:latest
MAINTAINER Robert Deutz <rdeutz@googlemail.com>

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# update the package sources
RUN apt-get update

# we use the enviroment variable to stop debconf from asking questions..
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y mysql-server apache2 php5 php5-cli php5-mysql php-pear mysql-client php5-xdebug php5-curl curl php5-mcrypt pear-channels wget unzip git fluxbox firefox openjdk-7-jre xvfb \
	dbus libasound2 libqt4-dbus libqt4-network libqtcore4 libqtgui4 libpython2.7 libqt4-xml libaudio2 fontconfig liblcms1 nano

# package install is finished, clean up
RUN apt-get clean # && rm -rf /var/lib/apt/lists/*

# Apache conf
ADD config/apache2.conf /etc/apache2/apache2.conf

# Apache site conf

ADD config/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf

# php.ini Apache
ADD config/php.ini-apache /etc/php5/apache2/php.ini

# install service files for runit
#ADD config/mysqld.service /etc/service/mysqld/run
#ADD config/apache2.service /etc/service/apache2/run

#RUN chmod a+x /etc/service/mysqld/run
#RUN chmod a+x /etc/service/apache2/run

# clean up tmp files (we don't need them for the image)
RUN rm -rf /tmp/* /var/tmp/*

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer
RUN composer self-update
