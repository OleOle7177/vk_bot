module Services 
  class Friend

    # определение уведомлен ли данный человек 
    def self.notified(token, user_id)
      messages = Services::VkApi.get_messages(token, user_id)
    
      notified = false
      messages['items'].each do |message|
        unless (message['body'] =~ /runnersclub_ru/).nil?
          notified = true
          break
        end
      end

      notified
    end

  end
end
