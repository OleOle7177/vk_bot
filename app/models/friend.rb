class Friend < ActiveRecord::Base
  validates :vk_id, presence: true, uniqueness: true

  has_many :fakes_friends
  has_many :fake, through: :fakes_friends

  scope :need_notify, -> { where(in_group: false, notified: false)}
end
