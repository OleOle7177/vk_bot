module Services
  class VkApi

    # Отправка сообщения user_id = кому отправлять 
    def self.send_message(token, user_id, text)

      conn = Faraday.new(:url => 'https://api.vk.com/') do |faraday|
        faraday.request :retry, max: 5, interval: 0.4,
                       interval_randomness: 0.5, backoff_factor: 2,
                       exceptions: ['Timeout::Error']
        faraday.request :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end


      response = conn.get 'method/messages.send',
        user_id: user_id,
        message: text,
        access_token: token, 
        v: 5.37,
        guid: Random.rand(99999999)

      body = JSON.parse response.body
    end

    # получение списка id-шников друзей
    def self.get_friends(user_id)

      conn = Faraday.new(:url => 'https://api.vk.com/') do |faraday|
        faraday.request :retry, max: 5, interval: 0.4,
                       interval_randomness: 0.5, backoff_factor: 2,
                       exceptions: ['Timeout::Error']
        faraday.request :url_encoded                        # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      response = conn.get 'method/friends.get',
        user_id: user_id,
        v: 5.37

      body = JSON.parse response.body
      body['response']
    end

    # получение участников группы
    def self.get_group_members(group_id, offset = 0)

      conn = Faraday.new(:url => 'https://api.vk.com/') do |faraday|
        faraday.request :retry, max: 5, interval: 0.4,
               interval_randomness: 0.5, backoff_factor: 2,
               exceptions: ['Timeout::Error']
        faraday.request :url_encoded           # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      response = conn.get 'method/groups.getMembers',
        group_id: group_id,
        offset: offset,
        sort: 'id_asc',
        v: 5.37

      body = JSON.parse response.body
      body['response']
    end


    # получение списка сообщений с данным пользователем
    def self.get_messages(token, user_id)

      conn = Faraday.new(:url => 'https://api.vk.com/') do |faraday|
        faraday.request :retry, max: 5, interval: 0.4,
               interval_randomness: 0.5, backoff_factor: 2,
               exceptions: ['Timeout::Error']
        faraday.request :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      response = conn.get 'method/messages.getHistory',
        user_id: user_id,
        access_token: token, 
        v: 5.37

      body = JSON.parse response.body
    
      body['response']
    end
  end
end


# https://oauth.vk.com/authorize?client_id=5112262&display=page&redirect_uri=blank.html&scope=friends,messages&response_type=token&v=5.37&revoke=1