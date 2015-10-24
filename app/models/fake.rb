class Fake < ActiveRecord::Base
  validates :first_name, :last_name, :login, :password, presence: true
  validates :login, uniqueness: true  

  # belongs_to :user
  has_many :fakes_friends
  has_many :friends, through: :fakes_friends
  has_many :statistics

  before_save :encrypt_password

  IV = "\xDA\x96n\xEC\xC3Z\xF3\x88'oR\x94+2\x9B0"

  def encrypt_password
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    cipher.key = Digest::SHA1.hexdigest('1799Pushkin1837')
    cipher.iv = IV

    encrypted = cipher.update(password) + cipher.final
    self.password = Base64.encode64(encrypted).encode('utf-8')
  end
  
  def decrypted_password
    decoded = Base64.decode64(password.encode('ascii-8bit'))

    decipher = OpenSSL::Cipher.new('aes-256-cbc')
    decipher.decrypt
    decipher.key = Digest::SHA1.hexdigest('1799Pushkin1837')
    decipher.iv = IV

    decipher.update(decoded) + decipher.final
  end


end
