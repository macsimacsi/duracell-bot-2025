class AddGasToParticipation < ActiveRecord::Migration[6.1]
  def change
    add_column :participations, :station_name, :string
  end
end
