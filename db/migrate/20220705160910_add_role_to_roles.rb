class AddRoleToRoles < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :role_create, :boolean
    add_column :roles, :role_read, :boolean
    add_column :roles, :role_update, :boolean
    add_column :roles, :role_delete, :boolean
  end
end
