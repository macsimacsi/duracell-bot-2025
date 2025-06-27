class RemovePrizeFromWinner < ActiveRecord::Migration[6.1]
  def change
    remove_reference :winners, :prize, null: false, foreign_key: true
  end
end
