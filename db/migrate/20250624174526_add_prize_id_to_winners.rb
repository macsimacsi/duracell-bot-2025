class AddPrizeIdToWinners < ActiveRecord::Migration[6.1]
  def change
    add_reference :winners, :prize, null: true, foreign_key: true
  end
end
