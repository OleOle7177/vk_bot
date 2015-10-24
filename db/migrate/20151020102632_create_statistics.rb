class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.integer   :fake_id, index: true
      t.datetime  :date
      t.integer   :event_type_id
      t.integer   :count
      t.string    :message
    end
  end
end
