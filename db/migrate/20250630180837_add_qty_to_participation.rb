class AddQtyToParticipation < ActiveRecord::Migration[6.1]
  def change
    add_column :participations, :product_qty, :integer
  end
end
