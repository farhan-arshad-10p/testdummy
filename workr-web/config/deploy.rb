require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'erb'
load 'deploy/assets'

set :application, 'workr'

set :stages, %w(staging)
set :default_stage, "staging"
ssh_options[:forward_agent] = true

default_run_options[:pty] = true
set :repository,  "git@gitorious.atomicobject.com:workr/workr.git"
set :scm, :git
set :branch, 'master'
set :scm_verbose, true
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 3


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :pre_permissions do
    run "#{try_sudo} chown -f -R atomic:atomic #{deploy_to}"
  end
  task :post_permissions do
    run "#{try_sudo} chown -R www-data:www-data #{deploy_to}"
  end

  task :custom_symlinks do
    %w[ s3 ].each do |file|
      run "ln -nfs #{shared_path}/config/#{file}.yml #{release_path}/config"
    end
    run "mkdir -p #{shared_path}/public/system"
    run "ln -nfs #{shared_path}/system/public/system  #{release_path}/public/system"
    run "ln -nfs #{shared_path}/solr  #{release_path}/solr"
  end
end

namespace :security_check do
  task :default do
    run "echo 'If you see a prompt for a password below, you do not have SSH agent forwarding set up properly: hit CTRL-C and run `ssh-add`' && git ls-remote git@gitorious.atomicobject.com:workr/workr.git > /dev/null"
  end
end

before 'deploy:pre_permissions','security_check'
before 'deploy:update_code','deploy:pre_permissions'
before 'deploy:pre_permissions','solr:stop'
before 'deploy:finalize_update', 'deploy:custom_symlinks'
after 'deploy:setup','deploy:post_permissions'
after 'deploy:restart','deploy:post_permissions'
before 'deploy:post_permissions','deploy:cleanup'
after 'deploy:post_permissions','solr:start'

namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} su www-data -c 'cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start'"
  end
  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} su www-data -c 'cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:stop' || true"
  end
  desc "reindex the whole database"
  task :reindex, :roles => :app do
    run "#{try_sudo} su www-data -c 'cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex[,,true]'"
  end
  desc "installs init script"
  task :install_init, :roles => :app do
    erb = ERB.new(File.read('config/deploy/solr.sh.erb'))
    put erb.result(binding), "/tmp/solr.sh"
    run "#{try_sudo} cp /tmp/solr.sh /etc/init.d/solr"
    run "#{try_sudo} chmod 755 /etc/init.d/solr"
    run "#{try_sudo} update-rc.d solr defaults"
  end
end
