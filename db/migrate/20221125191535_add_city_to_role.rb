class AddCityToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :city_create, :boolean
    add_column :roles, :city_read, :boolean
    add_column :roles, :city_update, :boolean
    add_column :roles, :city_delete, :boolean
  end
end
