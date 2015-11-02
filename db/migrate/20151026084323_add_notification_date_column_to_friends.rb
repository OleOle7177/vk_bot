class AddNotificationDateColumnToFriends < ActiveRecord::Migration
  def change
    add_column :friends, :notification_date, :datetime
  end
end
