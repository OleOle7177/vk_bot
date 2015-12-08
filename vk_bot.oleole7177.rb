#setup user environment
ENV['RAILS_ENV'] = 'production'
worker_processes(1)
preload_app true
user('hosting_oleole7177','optima_users')
timeout 40
listen '/var/sockets/hosting_oleole7177/vk_bot.oleole7177.sock', :umask => 0117
working_directory '/home/hosting_oleole7177/projects/vk_bot/current'
pid '/var/run/unicorn/hosting_oleole7177/vk_bot.oleole7177.pid'
stderr_path "/home/hosting_oleole7177/projects/vk_bot/current/log/unicorn.stderr.log"
stdout_path "/home/hosting_oleole7177/projects/vk_bot/current/log/unicorn.stdout.log"

GC.respond_to?(:copy_on_write_friendly=) and
GC.copy_on_write_friendly = true


before_fork do |server, worker|
   old_pid = "#{server.config[:pid]}.oldbin"
   if File.exists?(old_pid) && server.pid != old_pid
      begin
         Process.kill("QUIT", File.read(old_pid).to_i)
      rescue Errno::ENOENT, Errno::ESRCH
      end
   end
end

after_fork do |server, worker|
  # reset rails cache to not share memcached
  Rails.cache.reset if Rails.cache.respond_to? :reset
  # PG errors (not for Mongo)
  if (!Gem.loaded_specs['activerecord'].nil? &&
      Gem.loaded_specs['mongo'].nil? &&
      Gem.loaded_specs['mongoid'].nil?
  )
    ActiveRecord::Base.connection.reconnect!
  end

