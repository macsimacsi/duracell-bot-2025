class CreateGasStationDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :gas_station_details do |t|
      t.references :gas_station, null: false, foreign_key: true
      t.references :prize, null: false, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
