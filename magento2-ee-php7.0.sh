#!/bin/sh
basedir=$(dirname $(readlink -f $0))
calldir=$(pwd)

if [ "/tmp" = "$basedir" ]; then
    cd /vagrant/manifests
else
    cd "$basedir/manifests"
fi

set -e

export DEBIAN_FRONTEND=noninteractive

# install 'modules'
init/install.sh
sshd/install.sh
bash/install.sh
nginx/install.sh
php/install-7.0.sh
mysql/install.sh
redis/install.sh
memcached/install.sh
nodejs/install.sh
grunt/install.sh
mailcatcher/install.sh
varnish/install.sh
elasticsearch/install-5.sh # elasticsuite and magento commerce supported
rabbitmq/install.sh
magento/install.sh
mountdependency/install.sh -m '/var/www/website' -s 'nginx' -s 'php7.0-fpm'

if [ "/tmp" != "$basedir" ]; then
    cd "$calldir"
fi
