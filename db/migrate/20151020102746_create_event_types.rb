class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.string :name 
      t.string :systen_name, index: true
    end
  end
end
