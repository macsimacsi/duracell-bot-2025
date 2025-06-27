class RemoveColumnFromParticipations < ActiveRecord::Migration[6.1]
  def change
    remove_column :participations, :branch_promotion_id
    remove_column :participations, :city_id
    remove_column :participations, :city_promotion_id
    remove_column :participations, :gas_station_id
    remove_column :participations, :full_name
    remove_column :participations, :document
    remove_column :participations, :branch
    remove_column :participations, :img_path
    remove_column :participations, :quantity
    remove_column :participations, :station_name
    remove_column :participations, :status
  end
end
