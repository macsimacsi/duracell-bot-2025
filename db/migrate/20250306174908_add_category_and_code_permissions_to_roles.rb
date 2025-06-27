class AddCategoryAndCodePermissionsToRoles < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :category_read, :boolean, default: false
    add_column :roles, :category_update, :boolean, default: false
    add_column :roles, :category_create, :boolean, default: false
    add_column :roles, :category_delete, :boolean, default: false
    add_column :roles, :code_read, :boolean, default: false
    add_column :roles, :code_update, :boolean, default: false
    add_column :roles, :code_create, :boolean, default: false
    add_column :roles, :code_delete, :boolean, default: false
  end
end
