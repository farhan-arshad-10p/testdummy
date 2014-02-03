set :branch, 'staging'
set :user, "atomic"
set :use_sudo, true
set :deploy_to, "/var/www/workr.atomicobject.com"
set :stage_name, 'staging'
set :rails_env, 'staging'
server "workr.atomicobject.com", :app, :web, :db, primary: true
set :port, 8022
