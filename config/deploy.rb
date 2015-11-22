# config valid only for current version of Capistrano
lock '3.4.0'

set :repo_url, 'git@github.com:OleOle7177/vk_bot.git'
set :rvm_ruby_version, '2.2.2'

set :deploy_server,   "phosphorus.locum.ru"
set :rvm_ruby_string, "2.2.2"
set :rake,            "rvm use #{fetch(:rvm_ruby_string)} do bundle exec rake" 
set :bundle_cmd,      "rvm use #{fetch(:rvm_ruby_string)} do bundle"
set :user,            "hosting_oleole7177"
set :login,           "oleole7177"
set :use_sudo,        false
set :deploy_to,       "/home/#{fetch(:user)}/projects/#{fetch(:application)}"
set :unicorn_conf,    "/etc/unicorn/#{fetch(:application)}.#{fetch(:login)}.rb"
set :unicorn_pid,     "/var/run/unicorn/#{fetch(:user)}/#{fetch(:application)}.#{fetch(:login)}.pid"
role :app, 'phosphorus.locum.ru'
# set :bundle_dir,      File.join(fetch(:shared_path), 'gems')
# role :web,            deploy_server
# role :app,            deploy_server
# role :db,             deploy_server, :primary => true


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name


# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/password.yml', 'config/vk.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :keep_releases, 5

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# before 'deploy:finalize_update', 'set_current_release'
task :set_current_release do
  on roles :app do
    set :current_release, latest_release
  end
end

set :unicorn_start_cmd, "(cd #{deploy_to}/current; rvm use #{fetch(:rvm_ruby_string)} do bundle exec unicorn_rails -Dc #{fetch(:unicorn_conf)})"


after 'deploy:publishing', 'deploy:restart'

  namespace :deploy do

    desc "Start application"
    task :start do
      on roles :app do
        run unicorn_start_cmd
      end
    end

    desc "Stop application"
    task :stop do
      on roles :app do
        run "[ -f #{fetch(:unicorn_pid)} ] && kill -QUIT `cat #{fetch(:unicorn_pid)}`"
      end
    end

    desc "Restart Application"
    task :restart do
      on roles :app do
        run "[ -f #{fetch(:unicorn_pid)} ] && kill -USR2 `cat #{fetch(:unicorn_pid)}` || #{fetch(:unicorn_start_cmd)}"
      end
    end

end
