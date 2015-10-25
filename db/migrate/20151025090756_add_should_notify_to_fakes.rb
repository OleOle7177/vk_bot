class AddShouldNotifyToFakes < ActiveRecord::Migration
  def change
    add_column :fakes, :should_notify, :boolean, default: false, index: true
  end
end
