class AddLocalToParticipation < ActiveRecord::Migration[6.1]
  def change
    add_column :participations, :local_str, :string
  end
end
