class AddCodeToParticipation < ActiveRecord::Migration[6.1]
  def change
    add_column :participations, :code, :string, null: true
  end
end
