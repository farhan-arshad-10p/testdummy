set :branch, 'production'
set :user, "atomic"
set :use_sudo, true
set :deploy_to, "/var/www/workr.com"
set :stage_name, 'production'
set :rails_env, 'production'
server "23.92.26.73", :app, :web, :db, primary: true
