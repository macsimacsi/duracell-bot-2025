class AddPositionToPrizes < ActiveRecord::Migration[6.1]
  def change
    add_column :prizes, :position, :integer, default: 999
    add_column :prizes, :step, :integer, default: 0
  end
end
