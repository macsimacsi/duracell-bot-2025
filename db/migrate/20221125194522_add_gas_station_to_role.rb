class AddGasStationToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :gas_station_create, :boolean
    add_column :roles, :gas_station_read, :boolean
    add_column :roles, :gas_station_update, :boolean
    add_column :roles, :gas_station_delete, :boolean
  end
end
