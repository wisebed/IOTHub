IOTHub
======

## Installation ##
(this example was tested on a freshly set up debian vm)

### install packages ###
`mysql-server mysql-client libmysqlclient-dev build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config`
which will install a database (MySQL in this case, PostgreSQL should work just as well), multiple build tools and git.

### install RVM & ruby >= 1.9.3 ###
install RVM as a system wide installation:
`curl -L https://get.rvm.io | sudo bash -s stable`.
Make sure to install only ruby >= 1.9.3!

### install the app ###
`git clone git://github.com/MrMarvin/IOTHub.git` and `cd IOTHub; bundle install`.
Make sure you have set up the database with a user and database for IOTHub.
Change the config/database.yml to reflect your actual setup (adapter, host, username, password and database for the production environment).
Run `rake db:setup` to initialize the database.
Copy `config/secret_env_vars.yml` from the supplied example version and fill in the secrets and path settings. You might not want to store data in a temp-dir.
To automatically start the job_worker at system boot time, add the following line (after setting the path to IOTHub) to your users cron file:
`@reboot /bin/bash -l -c 'cd /path/to/app && RAILS_ENV=production script/delayed_job restart'`.
**change or delete the default admin user `admin@iothub` AS SOON AS POSSIBLE**


### install nginx+passenger ###
The most convenient way to get a recent version of nginx with passenger is to let passenger handle the compilation.
`gem install passenger` and follow the instructions given by `passenger-install-nginx-module`.
After nginx is successfully installed, copy the `config/initscript.sh` to your systems init.d/rc.d (most likely its `/etc/init.d/`). Rename it to "nginx".
Change the init-script according to your nginx-passenger installation: the path to the nginx binary might be different.
Copy the `config/nginx.conf` to your nginx installation directory, dont replace the existing conf yet.
Change the config according to your ruby installation path (see existing nginx.conf, it has the appropriate settings), also make sure it is pointing to your IOTHUb public/ directory as its document root.

