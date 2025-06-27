class AddStockToGasStationDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :gas_station_details, :stock, :integer, default: 0
  end
end
