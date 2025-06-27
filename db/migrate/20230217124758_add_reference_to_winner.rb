class AddReferenceToWinner < ActiveRecord::Migration[6.1]
  def change
    add_reference :winners, :prize, null: false, foreign_key: true
  end
end
