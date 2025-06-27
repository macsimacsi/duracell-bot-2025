class AddRolesToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :city_promotion_create, :boolean, default: false
    add_column :roles, :city_promotion_delete, :boolean, default: false
    add_column :roles, :city_promotion_read, :boolean, default: false
    add_column :roles, :city_promotion_update, :boolean, default: false
    add_column :roles, :branch_promotion_create, :boolean, default: false
    add_column :roles, :branch_promotion_delete, :boolean, default: false
    add_column :roles, :branch_promotion_read, :boolean, default: false
    add_column :roles, :branch_promotion_update, :boolean, default: false
  end
end
