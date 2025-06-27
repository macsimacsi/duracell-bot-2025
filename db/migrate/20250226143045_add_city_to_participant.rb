class AddCityToParticipant < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :city, :string
  end
end
