class AddBannedToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :banned_read, :boolean
    add_column :roles, :banned_create, :boolean
    add_column :roles, :banned_update, :boolean
    add_column :roles, :banned_delete, :boolean
  end
end
