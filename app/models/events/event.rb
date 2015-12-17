class Event < ActiveRecord::Base
  validates :fake_id, presence: true
  belongs_to :fake

  def to_s
    case type 
      when 'Error'
        "#{created_at.localtime.strftime('%d.%m.%Y %T')}: #{note}"
      when 'AddFriend'
        "#{created_at.localtime.strftime('%d.%m.%Y %T')}: Добавлено #{count} новых друзей"
      when 'SendMessage'
        "#{created_at.localtime.strftime('%d.%m.%Y %T')}: Отправлено #{count} новых сообщений"
    end
  end

end
