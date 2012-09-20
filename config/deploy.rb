set :stages, ['staging', 'production']
set :default_stage, 'production'
require 'capistrano/ext/multistage'

set :application, "chat"
set :repository,  "git@github.com:rubaidh/#{application}.git"
set :scm, :git
set :deploy_via, :remote_cache
set :user, application

set :bundle_cmd, 'ruby1.9.1 -S bundle'
require 'bundler/capistrano'

# Has to happen before the asset hooks.
namespace :db do
  task :symlink, except: { no_release: true } do
    run "ln -snf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
after "deploy:update_code", "db:symlink"

load 'deploy/assets'

set :use_sudo, false

ssh_options[:forward_agent] = true

# after 'deploy:restart', 'thin:restart'
namespace :thin do
  task :stop, roles: [ :app ], except: { no_release: true } do
    run "kill -TERM $(cat #{shared_path}/pids/thin.pid)"
  end

  task :start, roles: [ :app ], except: { no_release: true } do
    # Rely on upstart starting it again
  end

  task :restart, roles: [ :app ], except: { no_release: true } do
    stop
    start
  end
end
