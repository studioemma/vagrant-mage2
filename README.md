Magento 2 SE box
================

Get this repo
-------------

~~~
$ git clone --recursive https://github.com/studioemma/vagrant-mage2.git
~~~

When you forgot the --recursive part you can update the submodules recursive.

~~~
$ git submodule update --init --recursive
~~~

Config
------

The box *needs* a config.yml file. For everyones convenience there is a
`config.yml.example` provided.

~~~ yaml
project: 'magento2'
type: 'magento2'
ip: '192.168.254.253'
path: '../magento2'
memory: 1024
cpus: 1
~~~

So as you can see from the sample you can customize the project name (this will
have impact on the hostname shown to you when you ssh into the box). The
`host-only` ip address can be configured, so when you have more than one of
these boxes running you can do so without conflicting. The path to the root of
your project must be defined. And in case you must you can add more memory and
more cpus to the configuration to avoid sluggish responses when developing.

The type given in the configuration will cause a specific provisioning script
to be used.  Now we provide `magento2` and `magento2-ee` installations.

Grunt
-----

For frontend development there is a grunt config file available in magento so
grunt is globally installed in this box. For use with magento you also need a
project local part installed. You can find how to install grunt in the
(magento2 devdocs)[http://devdocs.magento.com/guides/v2.0/frontend-dev-guide/css-topics/css_debug.html#grunt_prereq].

What we need to do locally to get started with grunt is:

~~~ sh
$ cd /var/www/website
$ npm install
~~~

And we need to prepare the 'frontend' files. Here we must make sure there is
nothing left in the static folder, if there is something left there, there is a
big chance your grunt flow will not work properly. For custom theming do not
forget to update `dev/tools/grunt/configs/themes.js`.

~~~ sh
$ rm -rf pub/static/*
$ bin/magento dev:source-theme:deploy
$ grunt watch
~~~

Use the appropriate options for `dev:source-theme:deploy`!


Webserver
---------

We are using nginx with php-fpm. The modules needed for magento are installed
and are working. For convenience reasons there are aliases available for you to
restart nginx: `rn` and to restart php-fpm: `rp`.

The default vhost has no server name so it will respond on every address you
throw at it.

For php debugging xdebug is also installed and configured to automatically
callback to the 'caller' machine on port 9000. When you want to debug cli
scripts you must add the XDEBUG_CONFIG env var before running the php script.

~~~ sh
$ XDEBUG_CONFIG="remote_host=192.168.254.1" php myscript.php
~~~

PHPSTORM users might need to add more to have a smooth debugging experience.

~~~ sh
$ XDEBUG_CONFIG="remote_host=192.168.254.1" PHP_IDE_CONFIG="serverName=default" php myscript.php
~~~

Mysql
-----

By default mysql is installed and creates a database.
You can connect to the database with the following credentials:

~~~
user: root
password: toor
database: magento2
~~~

Memcached
---------

By default memcached is installed and can be used in magento to store the
sessions.  When you want to use memcached add the following to
`app/etc/env.php`:

~~~ php
...
  'session' => [
    'save' => 'memcached',
    'save_path' => '127.0.0.1:11211',
  ],
...
~~~

You can view the memcached stats and issue some commands to it via
phpmemacheadmin. The phpmemcachedadmin listens for a wildcard domain
`phpmemcacheadmin.*.dev`. When we are using `magento2` we can for example add
`phpmemcacheadmin.magento2.dev` to our hosts file.

~~~
192.168.254.253 phpmemcacheadmin.magento2.dev
~~~

Redis
-----

There is a redis server available and it can be used in magento for page
caching.  To use redis as page caching mechanism add the following to
`app/etc/env.php`:

~~~ php
...
  'cache' => [
    'frontend' => [
      'page_cache' => [
        'backend' => 'Cm_Cache_Backend_Redis',
        'backend_options' => [
          'server' => '127.0.0.1',
          'port' => '6379',
          'persistent' => '',
          'database' => 1,
          'password' => '',
          'force_standalone' => 0,
          'connect_retries' => 1,
        ]
      ]
    ],
  ],
...
~~~

phpredmin is also available on a wildcard domain `phpredmin.*.dev`. So we can
for example add the following to our hosts file:

~~~
192.168.254.253 phpredmin.magento2.dev
~~~

Mailcatcher
-----------

By default mailcatcher is running and listening on port 25. It is also added as
sendmail binary to your php setup.

To check the mails just browse to your defined ip port 8025. For example
http://192.168.254.253:1080, or if you have `192.168.254.253 magento2.dev` in
your hosts file http://magento2.dev:1080.

For convenience there is a wildcard domain `mailcatcher.*.dev`. So we can also
add thisone to our hosts file:

~~~
192.168.254.253 mailcatcher.magento2.dev
~~~

Varnish
-------

Varnish is setup with the default vcl for magento2. If you want to test how
your magento2 site behaves with varnish you can browse to
http://magento2.dev:6081.

TODO: add an admin dashboard for varnish

Beanstalkd
----------

There is Beanstalkd available when you want to do some simple queuing. This is
rather for internal projects only since for Magento we probably will use
rabbitmq by default.

For convenience there is a beanstalk admin installed which is reacheable on
http://phpbeanstalkadmin.magento2.dev

You could add an entry for that in your hosts file:

~~~
192.168.254.253 phpbeanstalkadmin.magento2.dev
~~~

Rabbitmq
--------

Available for Enterprise Magento2 installations.

The management interface of rabbitmq is installed and reachable on
http://rabbitmq.magento2.dev

~~~
192.168.254.253 rabbitmq.magento2.dev
~~~

Elasticsearch
-------------

Available for Enterprise Magneto2 installations.

Not yet available

Defaults
--------

- the website is always mapped to /var/www/website
- `www` will cd you to the website path
- `rn` will restart nginx
- `rp` will restart php-fpm

Example Hosts File
------------------

~~~
192.168.254.253 magento2.dev
192.168.254.253 phpbeanstalkadmin.magento2.dev
192.168.254.253 mailcatcher.magento2.dev
192.168.254.253 phpmemcacheadmin.magento2.dev
192.168.254.253 rabbitmq.magento2.dev
192.168.254.253 phpredmin.magento2.dev
~~~

Flavours
--------

Currently we have 2 available flavours:

- xenial-7.0 : ubuntu 16.04 with the latest php 7.0 available
- xenial-7.1 : ubuntu 16.04 with the latest php 7.1 available

To get the flavour you want checkout the corresponding branch in this repo.

WARNING
-------

The 7.1 version works but since mcrypt is deprecated you might need to do some
manual changes to get it all working fine.

Deprecated
----------

- trusty-5.5 : ubuntu 14.04 with the latest php 5.5 available
- trusty-5.6 : ubuntu 14.04 with the latest php 5.6 available
- trusty-7.0 : ubuntu 14.04 with the latest php 7.0 available

