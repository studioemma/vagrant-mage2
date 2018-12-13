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
php/install-5.6.sh
mysql/install.sh
redis/install.sh
mailcatcher/install.sh
# changes for magento1
sed \
    -e 's/magento2/magento1/g' \
    -e 's/pub/wwwroot/g' \
    -i /etc/nginx/sites-enabled/00_website.conf
systemctl restart nginx
# end magento1 changes
mountdependency/install.sh -m '/var/www/website' -s 'nginx' -s 'php7.0-fpm'
cleanup/install.sh

if [ "/tmp" != "$basedir" ]; then
    cd "$calldir"
fi
