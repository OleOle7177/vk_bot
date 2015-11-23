module Services
  class Fake 
    attr_accessor :fake

    def initialize(fake)
      @fake = fake
    end

    def notify
      # получаем друзей из вк
      check_authorize
      get_vk_friends
      sleep(0.5)
      # TODO сохранить friends_vk['count'] в БД

      # получаем id людей в группе и смотрим кто из них 
      # не помечен как в группе
      get_our_group_members
      sleep(0.5)

      view_notifications
      # Получить список друзей для этого фейка из бд 
      # с notified: false, in_group: false
      friends = @fake.friends.need_notify

      # для каждого из полученных друзей проверяем уведомлен он или нет
        # если нет, проверяем токен
        # то отправляем сообщение
        # ставим, что уведомлен
        # записываем количество отправленных сообщений
      friends.each do |friend|
        notified = Services::Friend.notified(@fake.access_token, friend.vk_id)
        sleep(0.5)
        unless notified
          p 'NEED TO SEND MESSAGE'
          p friend.vk_id
          sleep(rand(1..20))
          Services::VkApi.send_message(@fake.access_token, friend.vk_id, @fake.message)
          friend.notification_date = Time.zone.now
        end
        friend.notified = true
        friend.save
      end

    end

    def get_friends_in_group(group_id)
      # вызываем метод сервиса 
      # записываем в бд данные
    end

    # получаем друзей из вк и сохраняем в базу кого там еще нет
    def get_vk_friends(set_notified = false)
      # получаем друзей из вк
      friends_vk = Services::VkApi.get_friends(@fake.vk_id)

      # получаем друзей из бд
      friends_db = ::Friend.pluck(:vk_id)

      # смотрим разницу
      diff_friends = friends_vk['items'] - friends_db

      # готовим массив массивов для сохранения в бд
      diff_friends.map!{|friend| [friend, set_notified, false]}
      
      # сохраняем в бд
      ::Friend.import(['vk_id', 'notified', 'in_group'], diff_friends, validate: true)

      # готовим и сохраняем связи
      friend_ids = ::Friend.where(vk_id: friends_vk['items']).pluck(:id)
      friend_ids.map!{|x| [x, @fake.id]}

      ::FakesFriend.import(['friend_id', 'fake_id'], friend_ids, validate: true)
    end

    private

   # получение токена и времени жизни токена
    def authorize 
      count = 0 # число попыток
      begin
        agent = Mechanize.new
        
        auth_link = "https://oauth.vk.com/authorize?"+
          "client_id=#{VK_CONFIG['app_id']}&display=page&redirect_uri=blank.html&"+
          "scope=friends,messages,notifications&response_type=token&v=5.37&revoke=1"
          
        page = agent.get(auth_link)

        # логинимся в вк
        form = page.forms.first
        sleep 1
        form.fields.first.value = @fake.login
        sleep 1
        form.fields.last.value = @fake.decrypted_password
        page = agent.submit(form, form.buttons.first)


        # разрешаем приложению доступ к аккаунту
        form = page.forms.first
        form.fields[4].value = @fake.login
        sleep 1
        form.fields[5].value = @fake.decrypted_password
        sleep 1
        page = agent.submit(form, form.buttons.first) 

        sleep 1
        form = page.forms.last
        page = agent.submit(form, form.buttons.first)

        # забираем access_token и время жизни токена из параметров страницы, 
        # на которую произошел редирект
        uri = page.uri.to_s
        pp uri

        access_token = uri[/access_token=\w+/]
        expires_in = uri[/expires_in=\d+/]
        expires_in_sec = (expires_in[11..expires_in.length-1]).to_i

        access_token = access_token[13..access_token.length-1] 
        expires_at = Time.zone.now + expires_in_sec

        @fake.access_token = access_token
        @fake.token_expires_at = expires_at
        @fake.save

        {access_token: access_token, expires_at: expires_at}
      rescue StandardError => e
        count += 1
        retry if count <= 4
      end

    end


    # получаем людей нашей группы и сохраняем их в бд
    def get_our_group_members
      group_members_vk = Services::VkApi.get_group_members(VK_CONFIG['la_group_id'])
      iterations = group_members_vk['count']/1000
      
      for i in 0..iterations
        sleep(0.34)
        if i != 0
          group_members_vk = Services::VkApi.get_group_members(VK_CONFIG['la_group_id'], 
                                                               offset = i*1000)
        end

        # кто был в таблице друзей, но еще не был в группе,
        # а теперь в группе - обновляем in_group 
        ::Friend.where(vk_id: group_members_vk['items']).
                 update_all(in_group: true)
        
        friends_db = ::Friend.pluck(:vk_id)
        diff_friends = group_members_vk['items'] - friends_db
        diff_friends.map!{|friend| [friend, false, true]}

        ::Friend.import(['vk_id', 'notified', 'in_group'], diff_friends, validate: true)
      end

    end

    # проверяем истек ли токен, если да, то получаем новый
    def check_authorize
      p 'CHECK AUTHORIZE'

      if @fake.access_token.blank? || @fake.token_expires_at <= (Time.zone.now + rand(40..70).hour)        
        p 'NEED AUTHORIZE'
        authorize
        sleep(0.5)
      end
    end

    # просмотр оповещений
    def view_notifications
      Services::VkApi.view_notifications(@fake.access_token)
    end

  end
end
