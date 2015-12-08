class AddVkIdColumnToFakes < ActiveRecord::Migration
  def change
    add_column :fakes, :vk_id, :integer
  end
end
