class Fake < ActiveRecord::Base
  validates :first_name, :last_name, :login, :password, presence: true
  validates :login, uniqueness: true  

  # belongs_to :user
  has_many :fakes_friends
  has_many :friends, through: :fakes_friends
  has_many :statistics

  before_save :encrypt_password, if: :password_changed?

  IV = "\xDA\x96n\xEC\xC3Z\xF3\x88'oR\x94+2\x9B0"

  scope :should_notify, -> { where(send_messages: true) }


  def encrypt_password
    self.password = AES.encrypt(password, PASSWORD_CONFIG['key'])
  end
  
  def decrypted_password
    AES.decrypt(password, PASSWORD_CONFIG['key'])
  end


end
