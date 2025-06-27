class RemoveReferenceFromWinner < ActiveRecord::Migration[6.1]
  def change
    remove_reference :winners, :gas_station_detail, null: false, foreign_key: true
  end
end
