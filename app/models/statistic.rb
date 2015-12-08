class Statistic < ActiveRecord::Base
  belongs_to :fake
  belongs_to :event_type

  validates :fake, :event_type, presence: true
end
