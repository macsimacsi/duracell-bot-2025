class RemoveStateIdFromParticipations < ActiveRecord::Migration[6.1]
  def change
    remove_column :participations, :state_id, :integer
    remove_column :participations, :product_id, :integer
  end
end
