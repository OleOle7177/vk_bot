class Fake < ActiveRecord::Base
  validates :first_name, :last_name, :login, :password, :vk_id, 
            presence: true
  validates :login, uniqueness: true  

  has_many :fakes_friends
  has_many :friends, through: :fakes_friends
  has_many :events


  before_save :encrypt_password, if: :password_changed?

  IV = "\xDA\x96n\xEC\xC3Z\xF3\x88'oR\x94+2\x9B0"

  scope :should_notify, -> { where(schedule_notify: true) }


  def encrypt_password
    self.password = AES.encrypt(password, PASSWORD_CONFIG['key'])
  end
  
  def decrypted_password
    AES.decrypt(password, PASSWORD_CONFIG['key'])
  end

  def add_friends 
    AddFriend.where(fake_id: id)
  end

  def event_errors 
    EventError.where(fake_id: id)
  end

  def send_messages 
    SendMessage.where(fake_id: id)
  end

end
