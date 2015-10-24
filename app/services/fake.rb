module Services
  class Fake 
    attr_accessor :fake

    def initialize(fake)
      @fake = fake
    end

    def notify_friends
      # получаем друзей из вк
      get_vk_friends
      sleep(0.5)
      # TODO сохранить friends_vk['count'] в БД

      # получаем id людей в группе и смотрим кто из них 
      # не помечен как в группе
      get_our_group_members
      sleep(0.5)

      # Получить список друзей для этого фейка из бд 
      # с notified: false, in_group: false
      friends = @fake.friends.need_notify

      pp friends

      friends.each do |friend|
        check_authorize
        Services::VkApi.
      end
      # для каждого из полученных друзей проверяем уведомлен он или нет
        # если нет, проверяем токен
        # то отправляем сообщение
        # ставим, что уведомлен
        # записываем количество отправленных сообщений

    end

    def get_friends_in_group(group_id)
      # вызываем метод сервиса 
      # записываем в бд данные
    end

    private

   # получение токена и времени жизни токена
    def authorize 
      ################
      # login = '89529080025'
      # password = 'tyutchev'
      ################

      agent = Mechanize.new
      
      auth_link = "https://oauth.vk.com/authorize?"+
        "client_id=#{VK_CONFIG['app_id']}&display=page&redirect_uri=blank.html&"+
        "scope=friends,messages&response_type=token&v=5.37&revoke=1"
        
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
    end

    # получаем друзей из вк и сохраняем в базу кого там еще нет
    def get_vk_friends
      # получаем друзей из вк
      friends_vk = Services::VkApi.get_friends(@fake.vk_id)

      # получаем друзей из бд
      friends_db = ::Friend.pluck(:vk_id)

      # смотрим разницу
      diff_friends = friends_vk['items'] - friends_db

      # гтовим массив массивов для сохранения в бд
      diff_friends.map!{|friend| [friend, false, false]}

      # сохраняем в бд
      ::Friend.import(['vk_id', 'notified', 'in_group'], diff_friends)

      # готовим и сохраняем связи
      friend_ids = ::Friend.where(vk_id: friends_vk['items']).pluck(:id)
      friend_ids.map!{|x| [x, @fake.id]}

      ::FakesFriend.import(['friend_id', 'fake_id'], friend_ids)
    end

    # получаем людей нашей группы
    def get_our_group_members
      group_members_vk = Services::VkApi.get_group_members(VK_CONFIG['la_group_id'])
      
      # смотрим, есть ли данный человек в бд, 
      # если есть и у него in_group = false, 
      # то меняем in_group на true
      group_members_vk['items'].each do |member|
        member_db = ::Friend.find_by(vk_id: member)
        if member_db.present? 
          if member_db.in_group = false
            member_db.in_group = true
            member_db.save
          end
        end
      end

    end

    def check_authorize
      if @fake.token_expires_at <= Time.zone.now
        authorize
      end
    end


  end
end