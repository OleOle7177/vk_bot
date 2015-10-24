class RenameExpiresAtColumn < ActiveRecord::Migration
  def change
    rename_column :fakes, :expires_at, :token_expires_at
  end
end
