class NotifyWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 1

  def perform
    fakes = Fake.includes(:friends).where(schedule_notify: true)
    fakes.each do |fake|
      begin 
        service = Services::Fake.new(fake)
        service.notify
      rescue StandardError => e
        p "ERROR for fake with id=#{fake.id}"
        p e.message
        next
      end
    end
  end
end
