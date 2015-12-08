module Services
  class Application

    # Получение токена для приложения
    def self.get_app_token
      conn = Faraday.new(:url => 'https://oauth.vk.com/') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      response = conn.get "access_token", client_id: VK_CONFIG['app_id'],
        client_secret: VK_CONFIG['app_key'], 
        v: 5.37,
        grant_type: 'client_credentials'
      
      body = JSON.parse response.body
      $app_access_token = body['access_token']

    end

  end
end
