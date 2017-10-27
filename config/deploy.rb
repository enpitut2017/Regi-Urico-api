# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, "Regi-Urico-api"
set :repo_url, "git@github.com:enpitut2017/Regi-Urico-api.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/www/Regi-Urico-api"

set :puma_state, "/home/deploy/www/Regi-Urico-api/shared/tmp/states/puma.state"
set :puma_pid, "/home/deploy/www/Regi-Urico-api/shared/tmp/pids/puma.pid"
set :puma_bind, "unix:///home/deploy/www/Regi-Urico-api/shared/tmp/sockets/puma.sock"    #accept array for multi-bind

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  # uploads database.yml
  # bundle exec cap production deploy:upload_database
  desc 'Upload database.yml'
  task :upload_database do
    on roles(:app) do |_host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
    end
  end

  # uploads secrets.yml
  # bundle exec cap production deploy:upload_secrets
  desc 'Upload secrets.yml'
  task :upload_secrets do
    on roles(:app) do |_host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/secrets.yml', "#{shared_path}/config/secrets.yml")
    end
  end
end
