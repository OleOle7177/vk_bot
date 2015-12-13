class DestroyEventTypes < ActiveRecord::Migration
  def change
    drop_table :event_types
  end
end
