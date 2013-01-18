IOTHub
======

A web-app to run and show your wisebed experiments.
See it live: http://wisebed.itm.uni-luebeck.de:8886/

## Installation ##

### install and set up a database ###
`apt-get install mysql-server mysql-client libmysqlclient-dev`
which will install MySQL. PostgreSQL should work just as well.
Create a database for iothub and grant full access to it to an user.

### the toolchain: git, RVM & ruby >= 1.9.3 ###
`apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config`
install RVM:
`curl -L https://get.rvm.io | bash -s stable`.
Make sure to install only ruby >= 1.9.3!

### install the app ###
Use scp to copy your `database.yml` and `secret_env_vars.yml` file to the server. They go into `#{approot}/config/`.
Open the `config/deploy.rb` file and fill in your servers IP addresses and ssh usernames. Make sure your local user has ssh access with his priv/pub keys.

For the first time deployment (aka. cold deployment), call `cap deploy:cold` from your local application directory. This will ssh into the server, git clone the repository and initially fill the database.
As this process will install all dependent gems via bundler, we already have passenger installed. Start it using `passenger start -p 8881 --user iothub -e production -d` in `#{approot}/current/`.

Note: **change or delete the default admin user `admin@iothub` AS SOON AS POSSIBLE**

## deploying a new version to the server ##

Use capistrano: `cap deploy`. It will check out the current master, check and install gems, precompile assets and restart the delayed_job worker. However, it does not yet handle the application server restart correctly. To make sure its serving the freshly deployed version as soon as possible, stop/start passenger by hand.