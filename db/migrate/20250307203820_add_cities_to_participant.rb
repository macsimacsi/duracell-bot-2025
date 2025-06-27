class AddCitiesToParticipant < ActiveRecord::Migration[6.1]
  def change
    rename_column :participants, :city, :city_str
    add_reference :participants, :city, null: true, foreign_key: true
  end
end
