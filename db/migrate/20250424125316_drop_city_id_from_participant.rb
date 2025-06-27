class DropCityIdFromParticipant < ActiveRecord::Migration[6.1]
  def change
    remove_column :participants, :city_id, :integer if column_exists?(:participants, :city_id)
    remove_column :participants, :city_str, :string if column_exists?(:participants, :city_str)

    add_reference :participants, :state, foreign_key: true

    add_column :participants, :participations_count, :integer, default: 0, null: false
  end
end
