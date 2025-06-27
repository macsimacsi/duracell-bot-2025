class AddActiveToGasStations < ActiveRecord::Migration[6.1]
  def change
    add_column :gas_stations, :active, :boolean, default: true
  end
end
