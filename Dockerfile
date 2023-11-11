FROM nginx:alpine3.18-slim
#FROM php:7.4-fpm-alpine3.12
RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    xmlstarlet && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    imagemagick \
    bash \
    curl \
    git \
    supervisor \
    nginx \
    openssh-client \
    php7-bz2 \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-gd \
	php7-iconv \
	php7-ldap \
	php7-pecl-imagick \
	php7-pdo_mysql \
	php7-pdo_pgsql \
	php7-pdo_sqlite \
	php7-sqlite3 \
	php7-xml \
	php7-zip


# clear out any existing configs that ship with nginx
RUN mkdir -p /etc/nginx/sites-enabled

# load in our nginx config for dokuwiki
ADD dokuwiki.conf /etc/nginx/sites-enabled/

# load in our supervisor config that runs our processes (nginx/php/autobackup)
ADD supervisord.conf /etc/supervisord.conf

# create an unprivileged 'wiki' user to run commands under (w/ access to web content)
RUN adduser --disabled-password wiki
RUN addgroup  wiki www-data

# copy scripts/files
COPY wiki_home/* /home/wiki/
RUN chown -R wiki:wiki /home/wiki
RUN chmod +x /home/wiki/*.sh
# download the latest dokuwiki to /tmp
RUN curl -o /tmp/dokuwiki-stable.tgz "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
# publish nginx port
EXPOSE 3000

# get the party started
CMD /home/wiki/start.sh