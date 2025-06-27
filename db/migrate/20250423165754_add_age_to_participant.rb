class AddAgeToParticipant < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :age, :integer, null: false, default: 0
    add_index :participants, :age
  end
end
