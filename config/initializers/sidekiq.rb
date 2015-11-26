raw_yaml = YAML.load(File.read(File.join(Rails.root, 'config/redis.yml')))
REDIS_CONFIG = raw_yaml[Rails.env]

config = { url: "redis://#{REDIS_CONFIG['host']}:#{REDIS_CONFIG['port']}/", namespace: 'sidekiq_craft' }

Sidekiq.configure_server do |c|
  c.redis = config
end

Sidekiq.configure_client do |c|
  c.redis = config
end
