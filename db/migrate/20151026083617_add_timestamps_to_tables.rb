class AddTimestampsToTables < ActiveRecord::Migration
  def change
    add_column :fakes, :created_at, :datetime
    add_column :fakes, :updated_at, :datetime

    add_column :friends, :created_at, :datetime
    add_column :friends, :updated_at, :datetime

    add_column :fakes_friends, :created_at, :datetime
    add_column :fakes_friends, :updated_at, :datetime
  end
end
