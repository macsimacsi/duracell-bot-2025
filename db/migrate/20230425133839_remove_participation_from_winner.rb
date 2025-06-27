class RemoveParticipationFromWinner < ActiveRecord::Migration[6.1]
  def change
    remove_reference :winners, :participation, null: false, foreign_key: true
  end
end
