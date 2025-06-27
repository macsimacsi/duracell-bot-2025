class AddCityAndBranchToParticipation < ActiveRecord::Migration[6.1]
  def change
    add_reference :participations, :city_promotion, null: true, foreign_key: true
    add_reference :participations, :branch_promotion, null: true, foreign_key: true
  end
end
