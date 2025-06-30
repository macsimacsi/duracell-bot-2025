class AddParticipationsCountToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :participations_count, :integer
  end
end
