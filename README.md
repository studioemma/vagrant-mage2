Magento 2 SE box
================

Config
------

The box *needs* a config.yml file. For everyones convenience there is a
`config.yml.example` provided.

~~~ yaml
project: 'magento2'
ip: '192.168.254.90'
path: '../magento2'
memory: 1024
cpus: 1
~~~

So as you can see from the sample you can customize the project name (this will
have impact on the hostname shown to you when you ssh into the box). The
`host-only` ip address can be configured, so when you have more than one of
these boxes running you can do so without conflicting. The path to the root of
your project must be defined. And in case you must you can add more memory and
more cpus to the cofiguration to avoid sluggish responses when developing.

Grunt
-----

For frontend development there is a grunt config file available in magento so
grunt is globally installed in this box. For use with magento you also need a
project local part installed. This will be provided to you via the ant target
`local-install-grunt`.

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
192.168.254.90 phpmemcacheadmin.magento2.dev
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
192.168.254.90 phpredmin.magento2.dev
~~~

Mailcatcher
-----------

By default mailcatcher is running and listening on port 25. It is also added as
sendmail binary to your php setup.

To check the mails just browse to your defined ip port 8025. For example
http://192.168.254.90:8025, or if you have `192.168.254.90 magento2.dev` in
your hosts file http://magento2.dev:8025.

For convenience there is a wildcard domain `mailcatcher.*.dev`. So we can also
add thisone to our hosts file:

~~~
192.168.254.90 mailcatcher.magento2.dev
~~~

Defaults
--------

- the website is always mapped to /var/www/website
- `w` will cd you to the website path
- `ra` will restart apache for you
- `rp` will restart php-fpm
