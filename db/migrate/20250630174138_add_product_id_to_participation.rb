class AddProductIdToParticipation < ActiveRecord::Migration[6.1]
  def change
    add_reference :participations, :product, null: true, foreign_key: true
  end
end
