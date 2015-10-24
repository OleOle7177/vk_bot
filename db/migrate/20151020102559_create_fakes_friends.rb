class CreateFakesFriends < ActiveRecord::Migration
  def change
    create_table :fakes_friends do |t|
      t.integer :friend_id, index: true
      t.integer :fake_id, index: true
    end
  end
end
