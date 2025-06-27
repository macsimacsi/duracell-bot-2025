class AddGroupToGasStation < ActiveRecord::Migration[6.1]
  def change
    add_reference :gas_stations, :group, null: true, foreign_key: true
  end
end
