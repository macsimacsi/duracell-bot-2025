class AddStateIdToParticipations < ActiveRecord::Migration[6.1]
  def change
    add_column :participations, :state_id, :bigint
  end
end
