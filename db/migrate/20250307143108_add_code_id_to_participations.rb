class AddCodeIdToParticipations < ActiveRecord::Migration[6.1]
  def change
    add_reference :participations, :code, null: true, foreign_key: true
    rename_column :participations, :code, :code_str
  end
end
