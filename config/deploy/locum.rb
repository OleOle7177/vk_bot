role :app, %w(hosting_oleole7177@phosphorus.locum.ru)
role :web, %w(hosting_oleole7177@phosphorus.locum.ru)
role :db, %w(hosting_oleole7177@phosphorus.locum.ru)

set :ssh_options, forward_agent: true
set :rails_env, :production
