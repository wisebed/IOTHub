set :application, "IOTHub"
set :repository,  "https://github.com/MrMarvin/IOTHub.git"
set :brach, "master"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "localhost:2222"                          # Your HTTP server, Apache/etc
role :app, "localhost:2222"                          # This may be the same as your `Web` server
role :db,  "localhost:2222", :primary => true       # This is where Rails migrations will run
set :user, "marv"
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

require "rvm/capistrano"
set :rvm_type, :system

after "deploy:update_code" do
  run "cp #{File.join(deploy_to,"config","secret_env_vars.yml")} #{File.join(current_release,"config","secret_env_vars.yml")}"
  run "cp #{File.join(deploy_to,"config","database.yml")} #{File.join(current_release,"config","database.yml")}"
  run "cd #{current_release} && RAILS_EVN=production bundle exec rake assets:precompile"
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
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