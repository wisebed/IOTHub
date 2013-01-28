set :application, "IOTHub"
set :repository,  "git://github.com/wisebed/IOTHub.git"
set :brach, "master"

role :web, "wisebed.itm.uni-luebeck.de"                          # Your HTTP server, Apache/etc
role :app, "wisebed.itm.uni-luebeck.de"                          # This may be the same as your `Web` server
role :db,  "wisebed.itm.uni-luebeck.de", :primary => true       # This is where Rails migrations will run
set :user, "iothub"
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

require "rvm/capistrano"
set :rvm_type, ""

after "deploy:update_code" do
  run "cp #{File.join(deploy_to,"config","secret_env_vars.yml")} #{File.join(current_release,"config","secret_env_vars.yml")}"
  run "cp #{File.join(deploy_to,"config","database.yml")} #{File.join(current_release,"config","database.yml")}"
end
after "deploy:update_code", "bundle:install"
after "deploy:update_code" do
  run "cd #{current_release} && RAILS_ENV=production bundle exec rake assets:precompile"
end

before "deploy:create_symlink" do
  run "chmod +x #{current_release}/config/initscript.sh"
  run "#{current_release}/config/initscript.sh stop"
end
after "deploy:create_symlink" do
  run "chmod +x #{current_release}/config/initscript.sh"
  run "#{current_release}/config/initscript.sh start"
end

namespace :bundle do
  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{current_release} && bundle install  --without=test"
  end
end

require "delayed/recipes"
set :rails_env, 'production' #added for delayed_job
before "deploy:restart", "delayed_job:stop"
after  "deploy:restart", "delayed_job:start"
after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy", "deploy:cleanup"