FROM phusion/baseimage:0.9.16
MAINTAINER isqua <isqua@isqua.ru>

ENV HOME /root

# Add runit files for each service
ADD ./services/mysql /etc/service/mysql/run
ADD ./services/php-fpm /etc/service/php-fpm/run
ADD ./services/koken /etc/service/koken/run

# Installation helpers
ADD ./php/index.php /installer.php
ADD ./php/database.php /database.php
ADD ./php/user_setup.php /user_setup.php

# Cron
ADD ./shell/koken.sh /etc/cron.daily/koken

# Startup script
ADD ./shell/start.sh /etc/my_init.d/001_koken.sh

# Execute permissions where needed
RUN \
	chmod +x /etc/service/mysql/run && \
	chmod +x /etc/service/php-fpm/run && \
	chmod +x /etc/service/koken/run && \
	chmod +x /etc/cron.daily/koken && \
	chmod +x /etc/my_init.d/001_koken.sh

# LANG=C.UTF-8 line is needed for ondrej/php5 repository
RUN \
	export LANG=C.UTF-8 && \
	add-apt-repository ppa:mc3man/trusty-media && \
	add-apt-repository ppa:ondrej/php5-5.6 && \
	add-apt-repository -y ppa:rwky/graphicsmagick && \
	apt-get update && \
	apt-get -y install mysql-server mysql-client php5-fpm php5-mysql php5-curl php5-mcrypt graphicsmagick ffmpeg pwgen wget unzip && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
	sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
	sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini && \
	sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 101M/g" /etc/php5/fpm/php.ini && \
	sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
	sed -i -e "s/;pm.max_requests\s*=\s*500/pm.max_requests = 500/g" /etc/php5/fpm/pool.d/www.conf && \
	sed -i -e "s/;catch_workers_output/catch_workers_output/" /etc/php5/fpm/pool.d/www.conf && \
	echo "env[KOKEN_HOST] = 'koken-docker'" >> /etc/php5/fpm/pool.d/www.conf && \
	cp /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/images.conf && \
	sed -i -e "s/\[www\]/[images]/" /etc/php5/fpm/pool.d/images.conf && \
	sed -i -e "s#listen\s*=\s*/var/run/php5-fpm\.sock#listen = 9000#" /etc/php5/fpm/pool.d/www.conf && \
	sed -i -e "s#listen\s*=\s*/var/run/php5-fpm\.sock#listen = 9001#" /etc/php5/fpm/pool.d/images.conf

# Disable SSH
# RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Data volumes
VOLUME ["/var/www", "/var/lib/mysql"]

# Expose php ports to the host
EXPOSE 9000 9001

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
