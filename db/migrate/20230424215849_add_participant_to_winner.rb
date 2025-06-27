class AddParticipantToWinner < ActiveRecord::Migration[6.1]
  def change
    add_reference :winners, :participant, null: false, foreign_key: true
  end
end
