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
php/install-7.2.sh
mysql/install.sh
redis/install.sh
nodejs/install-10.sh
grunt/install.sh
mailcatcher/install.sh
varnish/install.sh
elasticsearch/install-5.sh # elasticsuite and magento commerce supported
rabbitmq/install.sh
magento/install.sh
mountdependency/install.sh -m '/var/www/website' -s 'nginx' -s 'php7.2-fpm'
cleanup/install.sh

if [ "/tmp" != "$basedir" ]; then
    cd "$calldir"
fi
