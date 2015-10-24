class CreateFakes < ActiveRecord::Migration
  def change
    create_table :fakes do |t|
      t.string    :first_name
      t.string    :last_name
      t.string    :login
      t.string    :password
      t.integer   :user_id, index: true
      t.text      :message
      t.string    :access_token
      t.datetime  :expires_at
    end
  end
end
