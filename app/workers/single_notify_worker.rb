class SingleNotifyWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 1

  def perform(fake_id)
    fake = Fake.find(fake_id)
    service = Services::Fake.new(fake)
    service.notify
  end
end
