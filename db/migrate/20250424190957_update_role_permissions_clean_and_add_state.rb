class UpdateRolePermissionsCleanAndAddState < ActiveRecord::Migration[6.1]
  def change
    remove_column :roles, :gas_station_create, :boolean
    remove_column :roles, :gas_station_read, :boolean
    remove_column :roles, :gas_station_update, :boolean
    remove_column :roles, :gas_station_delete, :boolean

    remove_column :roles, :category_create, :boolean
    remove_column :roles, :category_read, :boolean
    remove_column :roles, :category_update, :boolean
    remove_column :roles, :category_delete, :boolean

    remove_column :roles, :city_create, :boolean
    remove_column :roles, :city_read, :boolean
    remove_column :roles, :city_update, :boolean
    remove_column :roles, :city_delete, :boolean

    remove_column :roles, :product_create, :boolean
    remove_column :roles, :product_read, :boolean
    remove_column :roles, :product_update, :boolean
    remove_column :roles, :product_delete, :boolean

    remove_column :roles, :city_promotion_create, :boolean
    remove_column :roles, :city_promotion_read, :boolean
    remove_column :roles, :city_promotion_update, :boolean
    remove_column :roles, :city_promotion_delete, :boolean

    remove_column :roles, :branch_promotion_create, :boolean
    remove_column :roles, :branch_promotion_read, :boolean
    remove_column :roles, :branch_promotion_update, :boolean
    remove_column :roles, :branch_promotion_delete, :boolean

    add_column :roles, :state_create, :boolean, default: false
    add_column :roles, :state_read, :boolean, default: false
    add_column :roles, :state_update, :boolean, default: false
    add_column :roles, :state_delete, :boolean, default: false
  end
end
