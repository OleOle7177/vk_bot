class EventType < ActiveRecord::Base
  has_many :statistics
  validates :name, :system_name, presence: true
end
