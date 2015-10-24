class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :vk_id, index: true
      t.boolean :notified, default: false, index: true
      t.boolean :in_group, default: false, index: true
    end
  end
end
