class DropTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :gas_station_details, force: :cascade
    drop_table :gas_stations, force: :cascade
    drop_table :city_promotions, force: :cascade
    drop_table :branch_promotions, force: :cascade
  end
end
