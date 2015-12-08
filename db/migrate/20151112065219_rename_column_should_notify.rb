class RenameColumnShouldNotify < ActiveRecord::Migration
  def change
    rename_column :fakes, :should_notify, :schedule_notify
  end
end
