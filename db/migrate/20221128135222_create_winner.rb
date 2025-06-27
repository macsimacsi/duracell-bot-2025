class CreateWinner < ActiveRecord::Migration[6.1]
  def change
    create_table :winners do |t|
      t.references :participation, null: false, foreign_key: true, index: { unique: true}
      t.integer :status, default: 0
      t.references :gas_station_detail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
