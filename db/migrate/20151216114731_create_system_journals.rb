class CreateSystemJournals < ActiveRecord::Migration
  def change
    create_table :system_journals do |t|
      t.integer :fake_id, integer: true
      t.string  :type
      t.text    :note
      t.integer :count
      t.timestamps
    end
  end
end
