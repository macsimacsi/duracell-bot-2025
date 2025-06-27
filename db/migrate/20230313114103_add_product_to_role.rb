class AddProductToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :product_read, :boolean
    add_column :roles, :product_create, :boolean
    add_column :roles, :product_update, :boolean
    add_column :roles, :product_delete, :boolean
  end
end
