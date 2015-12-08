class FakesFriend < ActiveRecord::Base
  belongs_to :fake
  belongs_to :friend

  validates :fake_id, :friend_id, presence: true
  validates :friend_id, uniqueness: {scope: :fake_id}
end
